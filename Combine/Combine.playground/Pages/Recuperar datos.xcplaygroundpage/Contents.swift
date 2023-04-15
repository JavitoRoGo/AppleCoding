//: [Previous](@previous)

import Combine
import SwiftUI

// RECUPERANDO UNA ESTRUCTURA DE DATOS COMPLETA CON COMBINE

// Veamos cómo usar todo lo visto para recuperar datos a distintos niveles en una única llamada
// Recuperaremos un json con los 10 primeros artículos de la web de AppleCoding, para recuperar a su vez el título, el autor (a través de otro json en otra url), la imagen destacada del artículo (otra url), y el avatar del autor (del json de autores)

var subscribers = Set<AnyCancellable>()

struct Post: Identifiable, Codable {
    let id: Int
    
    struct Rendered: Codable {
        let rendered: String
    }
    
    let title: Rendered
    let excerpt: Rendered
    let jetpack_featured_media_url: URL
    let author: Int
}

struct Author: Identifiable, Codable {
    let id: Int
    let name: String
    
    struct AvatarURLs: Codable {
        let _96: URL
        enum CodingKeys: String, CodingKey {
            case _96 = "96"
        }
    }
    
    let avatar_urls: AvatarURLs
}

let url = URL(string: "https://applecoding.com/wp-json/wp/v2/posts")!
let urlAuthor = URL(string: "https://applecoding.com/wp-json/wp/v2/users")!

// Veamos qué hay que hacer para tener todas las llamadas en una y recuperar lo que nos interesa: los posts, luego del primero su título, autor, imagen destacada y avatar del autor
let postPublisher = URLSession.shared
    .dataTaskPublisher(for: url)
// en este ejemplo vamos a ignorar los errores para simplificar
    .map(\.data)
    .decode(type: [Post].self, decoder: JSONDecoder())
    .compactMap { $0.first } //hasta aquí ya tenemos los posts y el primero
    .eraseToAnyPublisher() //esto es para simplificar el tipo del publicador a AnyPublisher y usar la siguiente función

// Hay que crear una función para transformar los publishers, que reciba una url y devuelva un publisher que transforme en una imagen
func getImagePublisher(url: URL) -> AnyPublisher<UIImage,Error> {
    URLSession.shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .compactMap { UIImage(data: $0) }
        .share()
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
}

// Recuperar la imagen:
let imagePublisher = postPublisher
    .flatMap { post in
        getImagePublisher(url: post.jetpack_featured_media_url)
    }

// Recuperar el autor:
func getAuthorPublisher(author: Int) -> AnyPublisher<Author,Error> {
    URLSession.shared
        .dataTaskPublisher(for: urlAuthor.appendingPathComponent("\(author)"))
        .map(\.data)
        .decode(type: Author.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

let authorPubliser = postPublisher
    .flatMap { post in
        getAuthorPublisher(author: post.author)
    }

let avatarAuthorPubliser = postPublisher
    .flatMap { post in
        getAuthorPublisher(author: post.author)
    }
    .flatMap { author in
        getImagePublisher(url: author.avatar_urls._96)
    }

// Llamar para recuperarlo todo
Publishers.Zip4(postPublisher, imagePublisher, authorPubliser, avatarAuthorPubliser)
//lo que hace el zip es irse al receiveValue solo cuando ha recibido la señal de los 4 publicadores
    .sink { completion in
        if case .failure(let error) = completion {
            print("Algo ha fallado: \(error)")
        }
    } receiveValue: { post, image, author, avatar in
        print("Título: \(post.title.rendered)")
        print(image)
        image
        print("Autor: \(author.name)")
        print(avatar)
        avatar
    }
    .store(in: &subscribers)


//: [Next](@next)

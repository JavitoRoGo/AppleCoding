//
//  Model.swift
//  BatchImages
//
//  Created by Julio César Fernández Muñoz on 7/6/21.
//

import SwiftUI

struct Fotos: Identifiable {
    let id = UUID()
    let image: Image
}

struct ImagesData {
    let images: [URL] = [
            .init(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Steve_Jobs_Headshot_2010-CROP_%28cropped_2%29.jpg/1200px-Steve_Jobs_Headshot_2010-CROP_%28cropped_2%29.jpg")!,
            .init(string: "https://imagessl1.casadellibro.com/a/l/t7/81/9788499921181.jpg")!,
            .init(string: "https://i.blogs.es/f7b0ed/steve-jobs/1366_2000.jpg")!,
            .init(string: "https://cdn.businessinsider.es/sites/navi.axelspringer.es/public/styles/1200/public/media/image/2021/04/steve-jobs-presentacion-iphone-2290967.jpg?itok=Gd_P3WJy")!,
            .init(string: "https://i.blogs.es/93f41a/96d86ede-47f0-477e-9044-7c5bf3370d87/450_1000.jpeg")!,
            .init(string: "https://applesencia.com/files/2014/10/Steve-Jobs-1955-2011-640x480.jpg")!,
            .init(string: "https://e00-expansion.uecdn.es/assets/multimedia/imagenes/2015/07/07/14362912883888.jpg")!,
            .init(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRjPmXxmxAOm3Qf2MuAum9G27u6MFru36EeQ&usqp=CAU")!,
            .init(string: "https://cdn.andro4all.com/files/2012/08/stevejobs.jpg")!,
            .init(string: "https://cdn2.dineroenimagen.com/media/dinero/styles/gallerie/public/images/2021/03/steve-jobs-exito.jpg")!,
            .init(string: "https://www.economiadigital.es/wp-content/uploads/2020/10/steve-jobs-ipad-1000x665.jpeg")!,
            .init(string: "https://lh6.googleusercontent.com/proxy/RoSenxMkj7cL123rePNo-Xh9Cs_EFyElfnofsWzwNgffFAyz2DWr9qEJxOWpK9QQwyAufxxNBOOMCQ51RfbmpTUOiguIjoEltNL4JMoqHj8zaJYXQb9jKitd_TUwXKx-c4--JMXQ_pJ9Nchnoxe-Ufmgu_n5h_xRAU0oU08GEcP2k_DMK-smvp4TWw90Y5gN=w1200-h630-p-k-no-nu")!,
            .init(string: "https://1.bp.blogspot.com/-TZAtoAvci00/YBtJ258RjHI/AAAAAAAB2k8/MIC55mUqqjw84j3D6LSonp0kyYJjSVszgCLcBGAsYHQ/s530/apple%2Bmac%2B1.jpg")!,
            .init(string: "https://ichef.bbci.co.uk/news/640/amz/worldservice/live/assets/images/2015/03/13/150313120037_steve_jobs_624x351_getty.jpg")!,
//            .init(string: "https://t.ipadizate.es/2020/07/steve-jobs-ipod.jpg")!,
            .init(string: "https://imagenes.lainformacion.com/files/image_656_370/uploads/imagenes/2018/07/16/5b4cbb6bf16de.jpeg")!
        ]
}

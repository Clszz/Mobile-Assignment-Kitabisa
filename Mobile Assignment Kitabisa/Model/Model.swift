//
//  Model.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 08/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import Foundation

struct Movies : Decodable{
    let results:[Movie]
}

struct Movie : Decodable{
    let id:Int
    let original_title:String
    let overview:String
    let poster_path:String
    let release_date:String
}

struct MovieDetails : Decodable{
    let original_title:String
    let overview:String
    let poster_path:String
    let release_date:String
}

struct Reviews : Decodable{
    let results:[ReviewDetails]
}

struct ReviewDetails : Decodable{
    let author:String
    let content:String
    let id:String
    let url:String
}

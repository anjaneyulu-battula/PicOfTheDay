//
//  PicOfTheDayAPIModel.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 17/03/22.
//

import Foundation

enum MediaType: String, Decodable {
    case video = "video"
    case image = "image"
}

struct PicOfTheDayAPIModel: Decodable {
    let poctdDate: String
    let explanation: String
    let mediaType: MediaType
    let serviceVersion: String
    let title: String
    let url: String
    let thumbnailURL: String?

    private enum DecodingKeys: String, CodingKey {
        case poctdDate = "date"
        case explanation
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title
        case url
        case thumbnailURL = "thumbnail_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        self.poctdDate = try container.decode(String.self, forKey: .poctdDate)
        self.explanation = try container.decode(String.self, forKey: .explanation)
        self.mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        self.serviceVersion = try container.decode(String.self, forKey: .serviceVersion)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.thumbnailURL = try container.decodeIfPresent(String.self, forKey: .thumbnailURL)
    }
}


/*
//Video Data
{"date":"2022-02-01","explanation":"What will the Moon phase be on your birthday this year?  It is hard to predict because the Moon's appearance changes nightly.  As the Moon orbits the Earth, the half illuminated by the Sun first becomes increasingly visible, then decreasingly visible. The featured video animates images and altitude data taken by NASA's Moon-orbiting Lunar Reconnaissance Orbiter to show all 12 lunations that appear this year, 2022 -- as seen from Earth's northern (southern) hemisphere. A single lunation describes one full cycle of our Moon, including all of its phases. A full lunation takes about 29.5 days, just under a month (moon-th). As each lunation progresses, sunlight reflects from the Moon at different angles, and so illuminates different features differently.  During all of this, of course, the Moon always keeps the same face toward the Earth. What is less apparent night-to-night is that the Moon's apparent size changes slightly, and that a slight wobble called a libration occurs as the Moon progresses along its elliptical orbit.","media_type":"video","service_version":"v1","thumbnail_url":"https://img.youtube.com/vi/c4Xky6tlFyY/0.jpg","title":"Moon Phases 2022","url":"https://www.youtube.com/embed/c4Xky6tlFyY?rel=0&VQ=HD720"}
*/

/*
// Image Data
 {"date":"2022-02-02","explanation":"What's happening at the center of our galaxy? It's hard to tell with optical telescopes since visible light is blocked by intervening interstellar dust. In other bands of light, though, such as radio, the galactic center can be imaged and shows itself to be quite an interesting and active place.  The featured picture shows the latest image of our Milky Way's center by the MeerKAT array of 64 radio dishes in South Africa. Spanning four times the angular size of the Moon (2 degrees), the image is impressively vast, deep, and detailed.  Many known sources are shown in clear detail, including many with a prefix of Sgr, since the galactic center is in the direction of the constellation Sagittarius.  In our Galaxy's Center lies Sgr A, found here in the image center, which houses the Milky Way's central supermassive black hole.  Other sources in the image are not as well understood, including the Arc, just to the left of Sgr A, and numerous filamentary threads. Goals for MeerKAT include searching for radio emission from neutral hydrogen emitted in a much younger universe and brief but distant radio flashes.   Open Science: Browse 2,700+ codes in the Astrophysics Source Code Library","hdurl":"https://apod.nasa.gov/apod/image/2202/MwCenter_MeerKATMunoz_7530.jpg","media_type":"image","service_version":"v1","title":"The Galactic Center in Radio from MeerKAT","url":"https://apod.nasa.gov/apod/image/2202/MwCenter_MeerKATMunoz_1080.jpg"}
 */

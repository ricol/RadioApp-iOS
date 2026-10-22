//
//  RadioDataSource.swift
//  RadioApp
//
//  Created by Ricol Wang on 2026/10/22.
//

import Foundation

enum RadioDataSource {

    static func getStations() -> [RadioStation] {
        [
            // ===== Chinese Radio Stations =====
            RadioStation(
                id: "cnr1",
                name: "中国之声",
                streamUrl: "https://ngcdn001.cnr.cn/live/zgzs/index.m3u8",
                genre: "新闻",
                country: "中国",
                logoUrl: "https://sao.fm/wp-content/uploads/2021/11/1631523942979_3kp24fiif.jpeg",
                description: "中央人民广播电台 - 中国之声"
            ),
            RadioStation(
                id: "theSoundOfMusic",
                name: "CNR音乐之声",
                streamUrl: "https://rscdn.ajmide.com/r_69/live_69.m3u8?audio",
                genre: "娱乐",
                country: "中国",
                logoUrl: "https://sao.fm/wp-content/uploads/2021/11/1631523386950_lhenvkwul-768x768.jpeg",
                description: "中央人民广播电台 - CNR音乐之声"
            ),
            RadioStation(
                id: "SuzhouMusicRadio",
                name: "苏州音乐广播",
                streamUrl: "https://live.ximalaya.com/radio-first-page-app/live/65/64.m3u8",
                genre: "音乐",
                country: "中国",
                logoUrl: "https://radio5.cn/file/2023/04/2023051600444265.jpg",
                description: "苏州音乐广播FM102.8"
            ),
            RadioStation(
                id: "CGTN",
                name: "CGTN",
                streamUrl: "https://sk.cri.cn/am846.m3u8",
                genre: "News",
                country: "中国",
                logoUrl: "https://radio-res.cgtn.com/image/2101/1611302122849.jpg",
                description: "中国国际广播频道"
            ),

            // ===== International =====
            RadioStation(
                id: "ABCNews",
                name: "ABC news",
                streamUrl: "https://mediaserviceslive.akamaized.net/hls/live/2109425/newsradio/v0-221.m3u8",
                genre: "News",
                country: "Australia",
                logoUrl: "https://live-production.wcms.abc-cdn.net.au/21b0d1767efbf09b96ab726650be17f3?impolicy=wcms_crop_resize&cropH=3001&cropW=3001&xPos=0&yPos=0&width=100&height=100",
                description: "Australia Online Radio - ABC News"
            ),
            RadioStation(
                id: "ABCRadio",
                name: "ABC Radio",
                streamUrl: "https://abc.streamguys1.com/live/raeng/icecast.audio",
                genre: "General",
                country: "Australia",
                logoUrl: "https://cdn.instant.audio/images/logos/radioau-net/abc-australia.png",
                description: "Australia Online ABC Radio"
            ),
            RadioStation(
                id: "ClassicMusic",
                name: "Classic Music",
                streamUrl: "https://mediaserviceslive.akamaized.net/hls/live/2108547/classicfmnsw/v0-221.m3u8",
                genre: "Music",
                country: "Australia",
                logoUrl: "https://cdn.instant.audio/images/logos/radioau-net/abc-classic-fm.png",
                description: "Australia online classic music radio"
            )
        ]
    }

    static func getGenres(from stations: [RadioStation]) -> [String] {
        Array(Set(stations.map(\.genre))).sorted()
    }
}

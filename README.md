# scrapingDisasterInfo

## 災害情報
### 発生した災害(地震、噴火、津波)の情報をそれぞれ、Disasterを継承したEarthquake, Volcano, Tsunamiクラスのオブジェクトに格納する。
 Disaster
  - title
  - link
  - category
  - description
  - area
  - date
  - place
 
 Earthquake < Disaster
  - maximumintensity
  - magnitude
 
 Volcano < Disaster
  - warn_summary
 
 Tsunami < Disaster
  - magnitude
  
 ## 地域の被害情報
 ### 発生した災害(地震、噴火、津波)で被災した地域の被害情報をそれぞれ、DisasterAreaを継承したEarthquakeArea, VolcanoArea, TsunamiAreaクラスのオブジェクトに格納する。
 
 DisasterArea
 - place
 - date
 
 VolcanoArea < DisasterArea
 - warn_summary
 
 EarthquakeArea < DisasterArea
 - intensity
 
 TsunamiArea < DisasterArea
 - wave
 
 ## 実際に得られる情報の例
 ### Volcano
 ```
 {
  "@title":"口永良部島 - 噴火に関する火山観測報 - 11月15日21時0分発表",
  "@link":"http://weather.livedoor.com/volcano/509", 
  "@category":"火山情報",
  "@description":"火  山:口永良部島\n日  時:2018年11月15日21時00分(151200UTC)\n現  象:連続噴火継続\n15時以降の最高噴煙高度:火口上700m(海抜4200FT)\n火口:新岳\n10月25日...",
  "@warn_summary":"レベル3(入山規制)",
  "@place":"口永良部島",
  "@date":"2018年11月15日21時0分発表"
 }
 ```
  
  ### VolcanoArea
  ```
  {
    "@place":"鹿児島県屋久島町",
    "@date":"8月29日10時0分",
    "@warn_summary":"火口周辺警報:入山規制等"
   }
   ```
  
   ### Earthquake
   ```
   {
    "@title":"15日12:29 [ 最大震度 ] 震度 1 [ 震源地 ] 紀伊水道",
    "@link":"http://weather.livedoor.com/earthquake/2018-11-15-12-32?r=rss",
    "@category":"地震速報",
    "@description":"11月15日12時29分、紀伊水道を震源とする最大震度1の地震が発生しました。",
    "@date":"2018年11月15日12時29分ごろ",
    "@place":"紀伊水道 深さ 約10km",
    "@magnitude":"マグニチュード 2.9",
    "@maximumintensity":"震度 1"
   }
   ```
   
   ### EarthquakeArea
   ```
   {
    "@place":
      {
        "prefecture":"静岡県",
        "city":"藤枝市"
      },
      "@date":"2018年11月6日5時30分ごろ",
      "@intensity":"震度 1"
   }
   ```
   
   ### Tsunami
   ```
   {
    "@title":"11月05日 04:32 - 津波予報 - 気象庁 発表",
    "@link":"http://weather.livedoor.com/tsunami/20181105042617?r=rss",
    "@category":"津波速報",
    "@description":"若干の海面変動が予想されますが、被害の心配はありません。",
    "@date":"2018年11月5日4時26分 ごろ",
    "@place":"国後島付近  ",
    "@magnitude":"マグニチュード6.2"
   }
   ```
   
   ### TsunamiArea
   ```
   {
    "@place":"北海道太平洋沿岸東部",
    "@date":"2018年11月5日4時26分 ごろ",
    "@wave":"0.2m未満"
   }
   ```

    

 
 
 

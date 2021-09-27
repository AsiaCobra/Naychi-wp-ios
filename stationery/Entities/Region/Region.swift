//
//  Region.swift
//  stationery
//
//  Created by Codigo NOL on 04/01/2021.
//

import Foundation
import RealmSwift

public class Region: Object {
    
    @objc dynamic var id = "0"
    @objc dynamic var name = ""
    @objc dynamic var nameMm = ""
    var townships = List<String>()
    var townshipsMm = List<String>()
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
    public static func getAll() -> [Region] {
        
        var regions: [Region] = []
        
        for i in 0..<Region.states.count {
            let re = Region()
            re.id = "\(i)"
            re.name = Region.states[i]
            re.nameMm = Region.statesMm[i]
            let townsEng = Region.townships[i].sorted { $0 < $1 }
            for townen in townsEng { re.townships.append(townen) }
            
            let townsMm = Region.townshipsMm[i].sorted { $0 < $1 }
            for townmm in townsMm { re.townshipsMm.append(townmm) }
            
            regions.append(re)
        }
        return regions
    }
    
    public static func getFees(_ state: String, _ township: String) -> Int {
        if state != "Yangon" {
            let price = Constant.AppInfo.groupPrice?.items.filter{ $0.id == "default" }.first
            return price?.value ?? 1500
        }
        
        //get group id
        var id = ""
        for item in Constant.AppInfo.groupTownship?.items ?? [] {
            for towns in item.value {
                if towns.first == township {
                    id = item.id
                    break
                }
            }
            if !id.isEmpty { break }
        }
        
        for groupPrice in Constant.AppInfo.groupPrice?.items ?? [] {
            if groupPrice.id == id {
                return groupPrice.value
            }
        }
        
        return 0
    }
    
    public static func getStateMm(_ stateEng: String) -> String {
        guard let stateIndex = Region.states.firstIndex(of: stateEng) else { return "" }
        return Region.statesMm[stateIndex]
    }
    
    public static func getStateEng(_ stateMm: String) -> String {
        guard let stateIndex = Region.statesMm.firstIndex(of: stateMm) else { return "" }
        return Region.states[stateIndex]
    }
    
    public static func getTownshipMm(_ stateEng: String, _ townshipEng: String) -> String {
        if stateEng == "Yangon" {
            for item in Constant.AppInfo.groupTownship?.items ?? [] {
                for towns in item.value {
                    if towns.first == townshipEng { return towns.last ?? "" }
                }
            }
        }
        
        guard let stateIndex = Region.states.firstIndex(of: stateEng),
              let townIndex = Region.townships[stateIndex].firstIndex(of: townshipEng) else { return "" }
        return Region.townshipsMm[stateIndex][townIndex]
    }
    
    public static func getTownshipEng(_ stateMm: String, _ townshipMm: String) -> String {
        
        if stateMm == "ရန်ကုန်" {
            for item in Constant.AppInfo.groupTownship?.items ?? [] {
                for towns in item.value {
                    if towns.last == townshipMm { return towns.first ?? "" }
                }
            }
            return ""
        }
        
        guard let stateIndex = Region.statesMm.firstIndex(of: stateMm),
              let townIndex = Region.townshipsMm[stateIndex].firstIndex(of: townshipMm) else { return "" }
        return Region.townships[stateIndex][townIndex]
    }
    
    public static let states = ["Magway", "Mandalay", "Naypyidaw", "Kayah", "Shan", "Ayeyarwady", "Bago", "Yangon",
                                "Kachin", "Sagaing", "Kyin", "Mon", "Tanintharyi", "Chin", "Rakhine"]
    public static let statesMm = ["မကွေး", "မန္တလေး", "နေပြည်တော်", "ကယား", "ရှမ်း", "ဧရာဝတီ", "ပဲခူး", "ရန်ကုန်",
                                  "ကချင်", "စစ်ကိုင်း", "ကရင်", "မွန်", "တနင်္သာရီ", "ချင်း", "ရခိုင်"]
    
    public static let townships = [
        //MARK: Magway
        ["Gangaw", "Saw", "Tilin", "Chauck", "Magway", "Myothit", "Natmauk", "Taungdwingyi", "Yenangyaung", "Minbu", "Ngape", "Pwintbyu",
         "Salin", "Sidoktaya", "Myaing", "Pakokku", "Pauk", "Seikphyu", "Yesagyo", "Aunglan", "Kamma", "Mindon", "Minhla", "Sinbaungwe", "Thayet"],
        //MARK: Mandalay
        ["Kyaukse", "Myittha", "Sintgaing", "Tada-U", "Amarapura", "Aungmyethazan", "Chanayethazan", "Chanmyathazi", "Mahaaungmye", "Patheingyi",
         "Pyigyidagun", "Mahlaing", "Meiktila", "Thazi", "Wundwin", "Myingyan", "Natogyi", "Nganzun", "Thaungtha", "Kyaukpadaung",
         "Nyaung-U", "Madaya", "Mogok", "Pyinoolwin", "Singu", "Thabeikkyin", "Pyawbwe", "Yamethin"],
        //MARK: Naypyidaw
        ["Dekkhinathiri", "Lewe", "Pyinmana", "Zabuthiri", "Ottarathiri", "Pobbathiri", "Tatkon", "Zeyarthiri"],
        //MARK: Kayah
        ["Bawlakhe", "Hpasawng", "Mese", "Demoso", "Hpruso", "Loikaw", "Shadaw"],
        //MARK: Shan
        // "Mine Pauk", "Minelar", "Mineyu", "Minekoke", "Monehta", "Ponparkyin", "Tontar",  "Kyaing Lap", "Talay",
        ["Kengtung", "Mong Khet", "Mong La", "Mong Yang",  "Mong Hpayak", "Mong Yawng", "Mong Hsat", "Mong Ping", "Mong Tong", "Tachileik",
         //"Minelon", "Minengaw", "Chinshwehaw", "Mawhtike", "Manhero", "Monekoe", "Pansai", "Tamoenye", "Namtit", "Panglong", "Man Kan",
         "Kunlong", "Hsipaw", "Kyaukme", "Mantong", "Namhsan", "Namtu", "Nawnghkio", "Hsenwi", "Lashio", "Mongyai", "Tangyan",  "Konkyan",
         "Laukkaing", "Kutkai",  "Mu Se", "Namhkam",  "Hopang", "Mongmao",
         "Pangwaun",  "Matman", "Namphan", "Pangsang (Pan)", "Mabein", "Mongmit",
         // "Homane", "Kengtaung", "Karli", "Kholan", "Minenaung", "Minesan", "Panlong", "Indaw", "Kyauktalongyi", "Naungtayar",
          "Langkho", "Mawkmai", "Mong Nai", "Mong Pan",  "Kunhing", "Kyethi", "Lai-Hka", "Loilen",  "Mong Hsu",
         "Mong Kung", "Nansang", "Hopong", "Hsi Hseng",  "Kalaw",  "Lawksawk",  "Nyaungshwe",
         "Pekon", "Pingdaya", "Pinlaung", "Taunggyi", "Ywangan"],
        //MARK: Ayeyarwady
        //"Pyinsalu", "Ngayokaung", "Hainggyikyun", "Shwethaungyan", "Ngwehsaung", "Ngathaingchaung", "Ahmar",
        ["Hinthada", "Ingapu", "Kyangin", "Lemyethna", "Myanaung", "Zalun", "Labutta", "Mawlamyinegyun", "Danuphyu", "Ma-ubin",
         "Nyaungdon", "Pantanaw", "Einme", "Myaungmya", "Wakema",  "Kangyidaunk", "Kyaunggon", "Kyonpyaw", "Ngapudaw",
         "Pathein",  "Thabaung", "Yekyi", "Bogale", "Dedaye", "Kyaiklat", "Pyapon"],
        //MARK: Bago
        //"Aungmyin", "Intagaw", "Hpayargyi", "Pyuntaza", "Madauk", "Peinzalot", "Penwegon", "Shwegyin", "Kanyutkwin", "Kaytumadi",  "Kywebwe", "Mone", "Myohla", "Natthangwin", "Nyaungbinthar", "Swa", "Thagara", "Yaeni",  "Innma", "Okshipin", "Padaung", "Padigone", "Paukkaung", "Paungdale", "Paungde", "Pyay", "Shwedaung", "Sinmeswe", "Thegon", "Gyobingauk", "Letpadan", "Minhla", "Monyo", "Nattalin", "Okpho", "Ooethegone", "Sitkwin", "Tapun", "Tharrawaddy", "Thonze", "Zigon"
        ["Bago", "Daik-U", "Kawa", "Kyauktaga", "Nyaunglebin", "Shwegyin", "Thanatpin", "Waw", "Kyaukkyi", "Oktwin", "Pyu", "Tantabin", "Taungoo",
         "Yedashe"],
        //MARK: Yangon
        //"Tada", "Seikkan"
        ["Botataung", "Dagon Seikkan", "Dawbon", "East Dagon", "Mingala Taungnyunt", "North Dagon", "North Okkalapa", "Pazundaung", "South Dagon",
         "South Okkalapa", "Tamwe", "Thaketa", "Thingangyun", "Yankin", "Hlaingthaya", "Hlegu", "Hmawbi", "Htantabin", "Insein", "Mingaladon",
         "Shwepyitha", "Taikkyi", "Cocokyun", "Dala", "Kawhmu", "Kayan", "Kungyangon", "Kyauktan", "Seikkyi Kanaungto", "Thanlyin", "Thongwa",
         "Twante", "Ahlon", "Bahan", "Dagon", "Hlaing", "Kamayut", "Kyauktada", "Kyimyindaing", "Lanmadaw", "Latha", "Mayangon", "Pabedan", "Sanchaung"],
        //MARK: Kachin
        //"Dotphoneyan", "Lwegel", "Myohla", "Hopin", "Kamine", "Hsadone", "Hsinbo", "Kanpaikti", "Panwa", "Shinbwayyan", "Pannandin",
        ["Bhamo",  "Mansi", "Momauk", "Shwegu", "Hpakant", "Mogaung", "Mohnyin", "Chipwi", "Hsawlaw",  "Injangyang", "Myitkyina", "Tanai",
         "Waingmaw", "Kawnglanghpu", "Machanbaw", "Nogmung", "Putao", "Sumprabum"],
        //MARK: Sagaing
        //"Donhee", "Htanparkway", "Mobaingluk", "Pansaung", "Sonemara", "Kyaukmyaung", "Khampat", "Myothit",
        ["Hkamti", "Homalin", "Lahe", "Leshi Township (Lay Shi)", "Nanyun",  "Kanbalu", "Kyunhla", "Taze", "Ye-U", "Kale", "Kalewa", "Mingin",
         "Banmauk", "Indaw", "Katha", "Kawlin", "Pinlebu", "Tigyaing", "Wuntho", "Mawlaik", "Paungbyin", "Ayadaw", "Budalin", "Chaung-U", "Monywa",
         "Myaung", "Myinmu", "Sagaing", "Khin-U", "Shwebo", "Tabayin", "Wetlet", "Tamu", "Kani", "Pale", "Salingyi", "Yinmabin"],
        //MARK: Kyin
        //"Bawgali",  "Leiktho", "Paingkyon", "Shan Ywathit", "Kamamaung", "Kyaidon", "Payarthonezu", "Sugali", "Wawlaymyaing"
        ["Hlaignbwe", "Hpa-an", "Thandaunggyi", "Hpapun",  "Kawkareik", "Kyain Seikgyi", "Myawaddy"],
        //MARK: Mon
        //"Kyaikkhami", "Khawzar",  "Lamine", "Suvannawadi", "Mottama", "Zingyeik"
        ["Chaungzon", "Kyaikmaraw", "Mawlamyine", "Mudon", "Thanbyuzayat", "Ye", "Bilin", "Kyaikto", "Paung", "Thaton"],
        //MARK: Tanintharyi
        //"Kaleinaung", "Myitta", "Karathuri", "Khamaukgyi", "Pyigyimandaing", "Palauk",
        ["Dawei", "Launglon", "Thayetchaung", "Yebyu", "Bokpyin", "Kawthoung", "Kyunsu", "Myeik", "Palaw", "Tanintharyi"],
        //MARK: Chin
        //"Cikha", "Rikhuadal", "Reazu", "Sami"
        ["Falam", "Tiddim", "Ton Zang", "Hakha", "Htantlang", "Kanpetlet", "Matupi", "Mindat", "Paletwa"],
        //MARK: Rakhine
        //"Taungpyoletwe", "Kyeintali", "Maei",
        ["Ann", "Kyaukpyu", "Manaung", "Ramree", "Buthidaung", "Maungdaw",  "Pauktaw", "Ponnagyun", "Rathedaung", "Sittwe",
         "Gaw", "Thandwe", "Toungup", "Kyauktaw", "Minbya", "Mrauk-U", "Myebon"]
    ]
    
    public static let townshipsMm = [
        //MARK: Magway
        ["ဂန့်ဂေါ", "ဆော", "ထီးလင်း", "ချောက်", "မကွေး", "မြို့သစ်", "နတ်မောက်", "တောင်တွင်းကြီး", "ရေနံချောင်း", "မင်းဘူး", "ငဖဲ", "ပွင့်ဖြူ", "စလင်း", "စေတုတ္တရာ",
         "မြိုင်", "ပခုက္ကူ", "ပေါက်", "ဆိပ်ဖြူ", "ရေစကြို", "အောင်လံ", "ကံမ", "မင်းတုန်း", "မင်းလှ", "ဆင်ပေါင်ဝဲ", "သရက်"],
        //MARK: Mandalay
        ["ကျောက်ဆည်", "မြစ်သား", "စဉ့်ကိုင်", "တံတားဦး", "အမရပူရ", "အောင်မြေသာဇံ", "ချမ်းအေးသာဇံ", "ချမ်းမြသာစည်", "မဟာအောင်မြေ", "ပုသိမ်ကြီး", "ပြည်ကြီးတံခွန်",
         "မလှိုင်", "မိတ္ထီလာ", "သာစည်", "ဝမ်းတွင်း", "မြင်းခြံ", "နွားထိုးကြီး", "ငါန်းဇွန်", "တောင်သာ", "ကျောက်ပန်းတောင်း", "ညောင်ဦး", "မတ္တရာ",  "မိုးကုတ်", "ပြင်ဦးလွင်",
         "စဉ့်ကူ", "သပိတ်ကျင်း", "ပျော်ဘွယ်", "ရမည်းသင်း"],
        //MARK: Naypyidaw
        ["ဒက္ခိဏသီရိ", "လယ်ဝေး", "ပျဉ်းမနား", "ဇမ္ဗူသီရိ", "ဥတ္တရသီရိ", "ပုဗ္ဗသီရိ", "တပ်ကုန်း", "ဇေယျာသီရိ"],
        //MARK: Kayah
        ["ဘော်လခဲ",  "ဖားဆောင်း", "မယ်စဲ့", "ဒီမောဆိုး", "ဖရူးဆိုး", "လွိုင်ကော်", "ရှားတော"],
        //MARK: Shan
        ["ကျိုင်းတုံ", "မိုင်းခတ်", "မိုင်းလား", "မိုင်းယန်း", "မိုင်းဖြတ်", "မိုင်းယောင်း", "မိုင်းဆတ်", "မိုင်းပြင်း", "မိုင်းတုံ", "တာချီလိတ်", "ကွမ်းလုံ", "သီပေါ", "ကျောက်မဲ",
         "မန်တုံ", "နမ့်ဆန်", "နမ္မတူ", "နောင်ချို",  "သိန္နီ", "လားရှိုး", "မိုင်းရယ်", "တန့်ယန်း", "ကုန်းကြမ်း", "လောက်ကိုင်", "ကွတ်ခိုင်", "မူဆယ်", "နမ့်ခမ်း", "ဟိုပန်",
         "မိုင်းမော", "ပန်ဝိုင်", "မက်မန်း", "နားဖန်း", "ပန်ဆန်း", "မဘိမ်း", "မိုးမိတ်", "လင်းခေး", "မောက်မယ်", "မိုးနဲ", "မိုင်းပန်", "ကွန်ဟိန်း", "ကျေးသီး", "လဲချား",
         "လွိုင်လင်",  "မိုင်းရှူး", "မိုင်းကိုင်", "နမ့်စန်", "ဟိုပုံး", "ဆီဆိုင်", "ကလော",  "ရပ်စောက်", "ညောင်ရွှေ", "ဖယ်ခုံ", "ပင်းတယ", "ပင်လောင်း", "တောင်ကြီး", "ရွာငံ"],
        //MARK: Ayeyarwady
        [ "ဟင်္သာတ", "အင်္ဂပူ", "ကြံခင်း", "လေးမျက်နှာ", "မြန်အောင်", "ဇလွန်", "လပွတ္တာ", "မော်လမြိုင်ကျွန်း", "ဓနုဖြူ",  "မအူပင်", "ညောင်တုန်း", "ပန်းတနော်", "အိမ်မဲ",
          "မြောင်းမြ", "ဝါးခယ်မ", "ကန်ကြီးထောင့်", "ကျောင်းကုန်း", "ကျုံပျော်", "ငပုတော", "ပုသိမ်", "သာပေါင်း", "ရေကြည်", "ဘိုကလေး", "ဒေးဒရဲ", "ကျိုက်လတ်", "ဖျာပုံ"],
        //MARK: Bago
        ["ပဲခူး", "ဒိုက်ဦး", "ကဝ", "ကျောက်တံခါး", "ညောင်လေးပင်",  "ရွှေကျင်", "သနပ်ပင်", "ဝေါ", "ကျောက်ကြီး", "အုတ်တွင်း", "ဖြူး", "ထန်းတပင်", "တောင်ငူ", "ရေတာရှည်"],
        //MARK: Yangon
        ["ဗိုလ်တထောင်", "ဒဂုံမြို့သစ်ဆိပ်ကမ်း", "ဒေါပုံ", "ဒဂုံမြို့သစ်အရှေ့ပိုင်း", "မင်္ဂလာတောင်ညွန့်", "ဒဂုံမြို့သစ်မြောက်ပိုင်း", "မြောက်ဥက္ကလာပ", "ပုဇွန်တောင်", "ဒဂုံမြို့သစ်တောင်ပိုင်း",
         "တောင်ဥက္ကလာပ", "တာမွေ", "သာကေတ", "သင်္ဃန်းကျွန်း", "ရန်ကင်း", "လှိုင်သာယာ", "လှည်းကူး", "မှော်ဘီ", "ထန်းတပင်", "အင်းစိန်", "မင်္ဂလာဒုံ", "ရွှေပြည်သာ",
         "တိုက်ကြီး", "ကိုကိုးကျွန်း", "ဒလ", "ကော့မှူး", "ခရမ်း", "ကွမ်းခြံကုန်း", "ကျောက်တန်း", "ဆိပ်ကြီးခနောင်တို", "သန်လျင်", "သုံးခွ",  "တွံတေး", "အလုံ", "ဗဟန်း", "ဒဂုံ",
         "လှိုင်", "ကမာရွတ်", "ကျောက်တံတား", "ကြည့်မြင်တိုင်", "လမ်းမတော်", "လသာ", "မရမ်းကုန်း", "ပန်းဘဲတန်း", "စမ်းချောင်း"],
        //MARK: Kachin
        ["ဗန်းမော်", "မံစီ", "မိုးမောက်", "ရွှေကူ", "ဖားကန့်", "မိုးကောင်း", "မိုးညှင်း", "ချီဖွေ", "ဆော့လော်", "အင်ဂျန်းယန်", "မြစ်ကြီးနား", "တနိုင်း", "ဝိုင်းမော်", "ခေါင်လန်ဖူး",
         "မချမ်းဘော", "နောင်မွန်း", "ပူတာအို", "ဆွမ်ပရာဘွမ်"],
        //MARK: Sagaing
        ["ခန္တီး", "ဟုမ္မလင်း", "လဟယ်", "လေရှီး", "နန်းယွန်း", "ကန့်ဘလူ", "ကျွန်းလှ", "တန့်ဆည်", "ရေဦး", "ကလေး", "ကလေးဝ", "မင်းကင်း", "ဗန်းမောက်", "အင်းတော်",
         "ကသာ", "ကောလင်း", "ပင်လယ်ဘူး", "ထီးချိုင့်", "ဝန်းသို", "မော်လိုက်", "ဖောင်းပြင်", "အရာတော်", "ဘုတလင်", "ချောင်းဦး", "မုံရွာ", "မြောင်", "မြင်းမူ", "စစ်ကိုင်း",
         "ခင်ဦး", "ရွှေဘို", "ဒီပဲယင်း", "ဝက်လက်", "တမူး", "ကနီ", "ပုလဲ", "ဆားလင်းကြီး", "ယင်းမာပင်"],
        //MARK: Kyin
        ["လှိုင်းဘွဲ့", "ဘားအံ", "သံတောင်ကြီး", "ဖာပွန်", "ကော့ကရိတ်", "ကြာအင်းဆိပ်ကြီး", "မြဝတီ"],
        //MARK: Mon
        ["ချောင်းဆုံ", "ကျိုက်မရော", "မော်လမြိုင်", "မုဒုံ", "သံဖြူဇရပ်", "ရေး", "ဘီးလင်း", "ကျိုက်ထို", "ပေါင်", "သထုံ"],
        //MARK: Tanintharyi
        ["ထားဝယ်", "လောင်းလုံ", "သရက်ချောင်း", "ရေဖြူ", "ဘုတ်ပြင်း", "ကော့သောင်း", "ကျွန်းစု", "မြိတ်", "ပုလော", "တနင်္သာရီ"],
        //MARK: Chin
        ["ဖလမ်း", "တီးတိန်", "တွန်းဇံ", "ဟားခါး", "ထန်တလန်", "ကန်ပက်လက်", "မတူပီ", "မင်းတပ်", "ပလက်ဝ"],
        //MARK: Rakhine
        [ "အမ်း", "ကျောက်ဖြူ", "မာန်အောင်", "ရမ်းဗြဲ", "ဘူးသီးတောင်", "မောင်တော", "ပေါက်တော", "ပုဏ္ဏားကျွန်း", "ရသေ့တောင်", "စစ်တွေ",
          "ဂွ", "သံတွဲ", "တောင်ကုတ်", "ကျောက်တော်",  "မင်းပြား", "မြောက်ဦး", "မြေပုံ"]
    ]
}

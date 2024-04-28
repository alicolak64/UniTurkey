//
//  MockProvincesPage1.swift
//  UniTurkeyTests
//
//  Created by Ali Çolak on 23.04.2024.
//

import Foundation
@testable import UniTurkey


enum Page {
    // MARK: - Cases
    case page1
    case page2
    case page3
}

struct MockProvincePages {
    
    // MARK: - Provinces
    
    static let province1 = ProvinceResponse(id: 1, province: "ADANA", universities: [
        UniversityResponse(name: "ADANA BİLİM VE TEKNOLOJİ ÜNİVERSİTESİ", phone: "0 (322) 455 00 01", fax: "0 (322) 455 00 02", website: "https://www.adanabtu.edu.tr", email: "rektorluk@adanabtu.edu.tr" , address: "Gültepe Mahallesi, Çatalan Caddesi No:201/5 01250 Sarıçam/ADANA", rector: "MEHMET TÜMAY"),
        UniversityResponse(name: "ÇUKUROVA ÜNİVERSİTESİ", phone: "0 (322) 338 60 84", fax: "0 (322) 338 69 45", website: "www.cu.edu.tr", email: "genel-sekreter@cu.edu.tr", address: "Çukurova Üniversitesi Rektörlüğü 01330 Balcalı, Sarıçam / ADANA", rector: "MUSTAFA KİBAR")])
    
    static let province2 = ProvinceResponse(id: 2, province: "ADIYAMAN", universities: [
        UniversityResponse(name: "ADIYAMAN ÜNİVERSİTESİ", phone: "0 (416) 223 38 40", fax: "0 (416) 223 38 43", website: "https://www.adiyaman.edu.tr/", email: "bidb@adiyaman.edu.tr", address: "Altınşehir Mh. 3005 Sokak No:13 02040 / ADIYAMAN", rector: "MUSTAFA TALHA GÖNÜLLÜ")])
    
    static let province3 = ProvinceResponse(id: 3, province: "AFYONKARAHİSAR", universities: [
        UniversityResponse(name: "AFYON KOCATEPE ÜNİVERSİTESİ", phone: "0 (272) 228 14 18", fax: "0 (272) 228 14 19", website: "https://www.aku.edu.tr", email: "ozkalem@aku.edu.tr", address: "Afyon Kocatepe Üniversitesi Rektörlüğü 03200 Afyonkarahisar", rector: "MEHMET KARAKAŞ"),
        UniversityResponse(name: "AFYONKARAHİSAR SAĞLIK BİLİMLERİ ÜNİVERSİTESİ", phone: "-", fax: "-", website: "-", email: "-", address: "-", rector: "-")])
    
    static let province4 = ProvinceResponse(id: 4, province: "AĞRI", universities: [
        UniversityResponse(name: "AĞRI İBRAHİM ÇEÇEN ÜNİVERSİTESİ", phone: "0 (472) 215 00 00", fax: "0 (472) 215 00 01", website: "https://www.agri.edu.tr", email: "gensek@agri.edu.tr", address: "Ağrı İbrahim Çeçen Üniversitesi Rektörlüğü 04100 Ağrı", rector: "ABDULKADİR CARBAZ")])
    
    static let province5 = ProvinceResponse(id: 5, province: "AMASYA", universities: [
        UniversityResponse(name: "AMASYA ÜNİVERSİTESİ", phone: "0 (358) 211 50 05", fax: "0 (358) 218 01 04", website: "https://www.amasya.edu.tr",
                           email: "webadmin@amasya.edu.tr", address: "Akbilek Mah. Hakimiyet cad. No:4/3 PK: 05100 Merkez/AMASYA", rector: "METİN ORBAY")])
    
    static let province6 = ProvinceResponse(id: 6, province: "ANKARA", universities: [
        UniversityResponse(name: "ANKA TEKNOLOJİ ÜNİVERSİTESİ", phone: "-", fax: "-", website: "-", email: "-", address: "-", rector: "MEHMET ÇELİK"),
        UniversityResponse(name: "ANKARA HACI BAYRAM VELİ ÜNİVERSİTESİ", phone: "-", fax: "-", website: "-", email: "-", address: "-", rector: "-"),
        UniversityResponse(name: "ANKARA MEDİPOL ÜNİVERSİTESİ", phone: "-", fax: "-", website: "-", email: "-", address: "-", rector: "-"),
        UniversityResponse(name: "ANKARA MÜZİK VE GÜZEL SANATLAR ÜNİVERSİTESİ", phone: "-", fax: "-", website: "-", email: "-", address: "-", rector: "-"),
        UniversityResponse(name: "ANKARA SOSYAL BİLİMLER ÜNİVERSİTESİ", phone: "0 (312) 596 44 44", fax: "0 (312) 596 44 24", website: "https://www.asbu.edu.tr/", email: "bilgi@asbu.edu.tr", address: "Ankara Sosyal Bilimler Üniversitesi Rektörlüğü 06830 Beşevler/ANKARA", rector: "MEHMET BARCA"),
        UniversityResponse(name: "ANKARA ÜNİVERSİTESİ", phone: "0 (312) 223 43 61", fax: "0 (312) 223 63 70", website: "https://www.ankara.edu.tr", email: "https://www.ankara.edu.tr", address: "Ankara Üniversitesi Rektörlüğü Tandoğan/ANKARA", rector: "ERKAN İBİŞ"),
        UniversityResponse(name: "ANKARA YILDIRIM BEYAZIT ÜNİVERSİTESİ", phone: "0 (312) 324 15 55", fax: "0 (312) 324 15 05", website: "www.ybu.edu.tr", email: "destek@ybu.edu.tr", address: "Ankara Yıldırım Beyazıt Üniversitesi Esenboğa Külliyesi Esenboğa/Ankara", rector: "METİN DOĞAN"),
        UniversityResponse(name: "ATILIM ÜNİVERSİTESİ", phone: "0 (312) 586 82 00", fax: "0 (312) 586 80 91", website: "www.atilim.edu.tr", email: "atilimrektorluk@atilim.edu.tr", address: "Atılım Üniversitesi Kızılcaşar Mah. İncek Kampüsü Gölbaşı/İncek/ANKARA", rector: "MEHMET YILDIRIM ÜÇTUĞ"),
        UniversityResponse(name: "BAŞKENT ÜNİVERSİTESİ", phone: "0 (312) 246 66 66", fax: "0 (312) 246 67 56", website: "https://www.baskent.edu.tr", email: "rektorlk@baskent.edu.tr", address: "Başkent Üniversitesi Bağlıca Kampusu Eskişehir Yolu 20. Km Etimesgut/Ankara", rector: "ALİ HABERAL"),
        UniversityResponse(name: "ÇANKAYA ÜNİVERSİTESİ", phone: "0 (312) 233 10 00 - 0 (312) 284 45 00", fax: "0 (312) 233 10 29 - 0(312) 286 40 78", website: "https://www.cankaya.edu.tr/", email: "webadmin@cankaya.edu.tr", address: "Çankaya Üniversitesi  Merkez Kampüs : Eskişehir Yolu 29. Km Yukarıyurtçu Mahallesi, Mimar Sinan Caddesi No:4, 06790, Etimesgut / ANKARA", rector: "HAMDİ MOLLAMAHMUTOĞLU")])
    
    static let province7 = ProvinceResponse(id: 7, province: "ANTALYA", universities: [
        UniversityResponse(name: "AKDENİZ ÜNİVERSİTESİ", phone: "0 (242) 310 20 00", fax: "0 (242) 227 44 56", website: "https://www.akdeniz.edu.tr", email: "https://www.akdeniz.edu.tr", address: "Akdeniz Üniversitesi Rektörlüğü Dumlupınar Bulvarı 07058 Kampüs ANTALYA", rector: "ÖMER ÖZKAN")])
    
    static let province8 = ProvinceResponse(id: 8, province: "HATAY", universities: [
        UniversityResponse(name: "HATAY MUSTAFA KEMAL ÜNİVERSİTESİ", phone: "0 (326) 221 33 17 - 18 - 19", fax: "0 (326) 221 33 20", website: "https://www.mku.edu.tr", email: "rektorlukyaziisleri@mku.edu.tr" , address: "Alahan Tayfur Sökmen Kampüsü Dış kapı no:35 Adres No:3330417886 Alahan/Antakya/Hatay", rector: "HASAN KAYA"),
        UniversityResponse(name: "İSKENDERUN TEKNİK ÜNİVERSİTESİ", phone: "0 (326) 613 56 00", fax: "0 (326) 613 56 13", website: "www.iste.edu.tr", email: "ofis@iste.edu.tr", address: "İskenderun Teknik Üniversitesi Rektörlüğü Merkez Kampüs 31200 İskenderun/HATAY", rector: "TÜRKAY DERELİ")])
    
    static let province9 = ProvinceResponse(id: 9, province: "ISPARTA", universities: [
        UniversityResponse(name: "Isparta Uygulamalı Bilimler Üniversitesi", phone: "-", fax: "-", website: "-", email: "-", address: "-", rector: "-"),
        UniversityResponse(name: "SÜLEYMAN DEMİREL ÜNİVERSİTESİ", phone: "0 (246) 211 10 00", fax: "0 (246) 211 10 01", website: "https://www.sdu.edu.tr", email: "bidb@sdu.edu.tr", address: "Süleyman Demirel Üniversitesi Rektörlüğü 32260 Isparta", rector: "İLKER HÜSEYİN ÇARIKÇI")])
    
    static let province10 = ProvinceResponse(id: 10, province: "İSTANBUL", universities: [
        UniversityResponse(name: "ACIBADEM MEHMET ALİ AYDINLAR ÜNİVERSİTESİ", phone: "0 (216) 500 45 00", fax: "0 (216) 500 45 01", website: "https://www.acibadem.edu.tr", email: "-", address: "Acıbadem Üniversitesi Rektörlüğü Acıbadem Mahallesi Çeçen Sokak No:1 34718 Kadıköy/İSTANBUL", rector: "ALİ HÜSEYİN KUBİLAY"),
        UniversityResponse(name: "BAHÇEŞEHİR ÜNİVERSİTESİ", phone: "0 (212) 381 00 00", fax: "0 (212) 381 00 01", website: "https://www.bahcesehir.edu.tr", email: "-", address: "Bahçeşehir Üniversitesi Beşiktaş Kampüsü Çırağan Caddesi Osmanpaşa Mektebi Sokak No:4-6 Beşiktaş/İSTANBUL", rector: "RAHMİ AKTEPE"),
        UniversityResponse(name: "BEYKENT ÜNİVERSİTESİ", phone: "0 (212) 444 19 99", fax: "0 (212) 853 33 33", website: "https://www.beykent.edu.tr", email: "-", address: "Beykent Üniversitesi Ayazağa Kampüsü, Söğütözü Mah. Ayazağa Cad. No:4 34396 Maslak/İSTANBUL", rector: "MEHMET DURMAN")])
    
    static let province11 = ProvinceResponse(id: 61 , province: "TRABZON", universities: [
        UniversityResponse(name: "KARADENİZ TEKNİK ÜNİVERSİTESİ", phone: "0 (462) 377 20 00", fax: "0 (462) 325 34 84", website: "https://www.ktu.edu.tr", email: "-", address: "Karadeniz Teknik Üniversitesi Rektörlüğü 61080 Trabzon", rector: "MUSTAFA YÜKSEL"),
        UniversityResponse(name: "KTÜ DENİZ BİLİMLERİ FAKÜLTESİ", phone: "0 (462) 377 20 00", fax: "0 (462) 325 34 84", website: "https://www.ktu.edu.tr", email: "-", address: "Karadeniz Teknik Üniversitesi Rektörlüğü 61080 Trabzon", rector: "MUSTAFA YÜKSEL")])
    
    static let province12 = ProvinceResponse(id: 62, province: "TUNCELİ", universities: [
        UniversityResponse(name: "MUNZUR ÜNİVERSİTESİ", phone: "0 (428) 213 20 00", fax: "0 (428) 213 20 01", website: "https://www.munzur.edu.tr", email: "-", address: "Munzur Üniversitesi Rektörlüğü 62000 Tunceli", rector: "ALİ KEMAL ÇAPAN")])
    
    static let province13 = ProvinceResponse(id: 63, province: "ŞANLIURFA", universities: [
        UniversityResponse(name: "HARRAN ÜNİVERSİTESİ", phone: "0 (414) 318 30 00", fax: "0 (414) 318 30 01", website: "https://www.harran.edu.tr", email: "-", address: "Harran Üniversitesi Rektörlüğü 63300 Şanlıurfa", rector: "RAMAZAN TAŞALTIN")])
    
    static let province14 = ProvinceResponse(id: 64, province: "UŞAK", universities: [
        UniversityResponse(name: "UŞAK ÜNİVERSİTESİ", phone: "0 (276) 221 21 21", fax: "0 (276) 221 21 22", website: "https://www.usak.edu.tr", email: "-", address: "Uşak Üniversitesi Rektörlüğü 64200 Uşak", rector: "ERDOĞAN TÜRKER")])
    
    static let province15 = ProvinceResponse(id: 65, province: "VAN", universities: [
        UniversityResponse(name: "VAN YÜZÜNCÜ YIL ÜNİVERSİTESİ", phone: "0 (432) 225 10 00", fax: "0 (432) 225 10 01", website: "https://www.yyu.edu.tr", email: "-", address: "Van Yüzüncü Yıl Üniversitesi Rektörlüğü 65080 Van", rector: "HAMZA KANDUR")])
    
    
    // MARK: - Province Paged
    
    static let page1Provinces = [province1, province2, province3, province4, province5]
    static let page2Provinces = [province6, province7, province8, province9, province10]
    static let page3Provinces = [province11, province12, province13, province14, province15]
    
    static let page1 = ProvincePageResponse(currentPage: 1, totalPages: 3, totalProvinces: 15, provincePerPage: 5, pageSize: 3, provinces: page1Provinces)
    static let page2 = ProvincePageResponse(currentPage: 2, totalPages: 3, totalProvinces: 15, provincePerPage: 5, pageSize: 3, provinces: page2Provinces)
    static let page3 = ProvincePageResponse(currentPage: 3, totalPages: 3, totalProvinces: 15, provincePerPage: 5, pageSize: 3, provinces: page3Provinces)
    
    
    // MARK: - Get Province Page Method
    
    static func getProvincePage(page: Page) -> ProvincePageResponse {
        switch page {
        case .page1:
            return page1
        case .page2:
            return page2
        case .page3:
            return page3
        }
    }
    
}





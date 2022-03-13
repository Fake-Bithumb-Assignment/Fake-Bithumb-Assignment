//
//  Coin.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/01.
//

import Foundation

enum Coin: String, CaseIterable {
    case BTC, ETH, BNB, XRP
    case LUNA, SOL, ADA, DOT
    case DOGE, MATIC, CRO, DAI
    case ATOM, LTC, LINK, UNI
    case TRX, BCH, ALGO, MANA
    case XLM, ETC, SAND, AXS
    case VET, EGLD, THETA, KLAY
    case XTZ, EOS, AAVE, MKR
    case WAVES, CAKE, GALA, GRT
    case BSV, ENJ, CHZ, KSM
    case BAT, LRC, XEM, TFUEL
    case XYM, BORA, COMP, YFI
    case WEMIX, QTUM, BNT, WAXP
    case ANKR, OMG, UMA, LPT
    case BTG, RLY, ZIL, ICX
    case ONT, ZRX, NU, SNX
    case WOO, IOST, GLM, SUSHI
    case HIVE, UOS, JST, CKB
    case REN, OCEAN, CELR, C98
    case KNC, SRM, SXP, POWR
    case CHR, COTI, ALICE, FX
    case MED, ONG, CTSI, ORBS
    case PUNDIX, BOBA, MXC, SNT
    case RSR, ELF, BFC, NMR
    case ORC, OXT, REP, DAO
    case RLC, STRAX, GXC, STEEM
    case CENNZ, META, SUN, XPR
    case BCD, XVS, SSX, BAKE
    case QKC, MTL, VRA, MIR
    case ARPA, BAL, CTK, LOOM
    case AERGO, AQT, LINA, MLK
    case DAD, ASM, COS, BIOT
    case MEV, VELO, MIX, CTXC
    case FRONT, CYCLUB, BEL, AION
    case MAP, FCT2, WTC, BOA
    case CON, SOFI, GOM2, MVC
    case VSYS, GO, WOZX, WICC
    case EVZ, BUGGER, SOC, GHX
    case XNO, EGG, IPX, VALOR
    case WOM, WIKEN, RINGX, APM
    case TRV, BLY, ANW, APIX
    case POLA, PCI, TDROP, CTC
    case CWD, COLA, AWO, ADP
    case ANV, ARW, SPRT, MM, ATOLO
    
    var rawValue: String {
        switch self {
        case .BTC:      return "비트코인"
        case .ETH:      return "이더리움"
        case .BNB:      return "바이낸스코인"
        case .XRP:      return "리플"
        case .LUNA:     return "루나"
        case .SOL:      return "솔라나"
        case .ADA:      return "에이다"
        case .DOT:      return "폴카닷"
        case .DOGE:     return "도지코인"
        case .MATIC:    return "폴리곤"
        case .CRO:      return "크로노스"
        case .DAI:      return "다이"
        case .ATOM:     return "코스모스"
        case .LTC:      return "라이트코인"
        case .LINK:     return "체인링크"
        case .UNI:      return "유니스왑"
        case .TRX:      return "트론"
        case .BCH:      return "비트코인 캐시"
        case .ALGO:     return "알고랜드"
        case .MANA:     return "디샌트럴랜드"
        case .XLM:      return "스텔라루멘"
        case .ETC:      return "이더리움 클래식"
        case .SAND:     return "샌드박스"
        case .AXS:      return "엑시인피니티"
        case .VET:      return "비체인"
        case .EGLD:     return "엘론드"
        case .THETA:    return "세타토큰"
        case .KLAY:     return "클레이튼"
        case .XTZ:      return "테조스"
        case .EOS:      return "이오스"
        case .AAVE:     return "에이브"
        case .MKR:      return "메이커"
        case .WAVES:    return "웨이브"
        case .CAKE:     return "팬케이크스왑"
        case .GALA:     return "갈라"
        case .GRT:      return "더그래프"
        case .BSV:      return "비트코인에스브이"
        case .ENJ:      return "엔진코인"
        case .CHZ:      return "칠리즈"
        case .KSM:      return "쿠사마"
        case .BAT:      return "베이직어텐션토큰"
        case .LRC:      return "루프링"
        case .XEM:      return "넴"
        case .TFUEL:    return "쎄타퓨엘"
        case .XYM:      return "심볼"
        case .BORA:     return "보라"
        case .COMP:     return "컴파운드"
        case .YFI:      return "연파이낸스"
        case .WEMIX:    return "위믹스"
        case .QTUM:     return "퀀텀"
        case .BNT:      return "뱅코르"
        case .WAXP:     return "왁스"
        case .ANKR:     return "앵커"
        case .OMG:      return "오미세고"
        case .UMA:      return "우마"
        case .LPT:      return "라이브피어"
        case .BTG:      return "비트코인 골드"
        case .RLY:      return "랠리"
        case .ZIL:      return "질리카"
        case .ICX:      return "아이콘"
        case .ONT:      return "온톨로지"
        case .ZRX:      return "제로엑스"
        case .NU:       return "누사이퍼"
        case .SNX:      return "신세틱스"
        case .WOO:      return "우네트워크"
        case .IOST:     return "이오스트"
        case .GLM:      return "골렘"
        case .SUSHI:    return "스시스왑"
        case .HIVE:     return "허아부"
        case .UOS:      return "울트라"
        case .JST:      return "저스트"
        case .CKB:      return "너보스"
        case .REN:      return "렌"
        case .OCEAN:    return "오션프로토콜"
        case .CELR:     return "셀러네트워크"
        case .C98:      return "코인98"
        case .KNC:      return "카이버 네트워크"
        case .SRM:      return "세럼"
        case .SXP:      return "스와이프"
        case .POWR:     return "파워렛저"
        case .CHR:      return "크로미아"
        case .COTI:     return "코티"
        case .ALICE:    return "마이네이버앨리스"
        case .FX:       return "펑션엑스"
        case .MED:      return "메디블록"
        case .ONG:      return "온톨로지가스"
        case .CTSI:     return "카르테시"
        case .ORBS:     return "오브스"
        case .PUNDIX:   return "펀디엑스"
        case .BOBA:     return "보바토큰"
        case .MXC:      return "머신익스체인지코인"
        case .SNT:      return "스테이터스네트워크토큰"
        case .RSR:      return "리저브라이트"
        case .ELF:      return "엘프"
        case .BFC:      return "바이프로스트"
        case .NMR:      return "뉴메레르"
        case .ORC:      return "오르빗 체인"
        case .OXT:      return "오키드"
        case .REP:      return "어거"
        case .DAO:      return "다오메이커"
        case .RLC:      return "아이젝"
        case .STRAX:    return "스트라티스"
        case .GXC:      return "지엑스체인"
        case .STEEM:    return "스팀"
        case .CENNZ:    return "센트럴리티"
        case .META:     return "메타디움"
        case .SUN:      return "썬"
        case .XPR:      return "프로톤"
        case .BCD:      return "비트코인 다이아몬드"
        case .XVS:      return "비너스"
        case .SSX:      return "썸씽"
        case .BAKE:     return "베이커리토큰"
        case .QKC:      return "쿼크체인"
        case .MTL:      return "메탈"
        case .VRA:      return "베라시티"
        case .MIR:      return "미러 프로토콜"
        case .ARPA:     return "알파체인"
        case .BAL:      return "밸런서"
        case .CTK:      return "써틱"
        case .LOOM:     return "룸네트워크"
        case .AERGO:    return "아르고"
        case .AQT:      return "알파쿼크"
        case .LINA:     return "리니어파이낸스"
        case .MLK:      return "밀크"
        case .DAD:      return "다드"
        case .ASM:      return "어셈블프로토콜"
        case .COS:      return "콘텐토스"
        case .BIOT:     return "바이오패스포트"
        case .MEV:      return "미버스"
        case .VELO:     return "벨로프로토콜"
        case .MIX:      return "믹스마블"
        case .CTXC:     return "코르텍스"
        case .FRONT:    return "프론티어"
        case .CYCLUB:   return "싸이클럽"
        case .BEL:      return "벨라프로토콜"
        case .AION:     return "아이온"
        case .MAP:      return "맵프로토콜"
        case .FCT2:     return "피르마체인"
        case .WTC:      return "월튼체인"
        case .BOA:      return "보아"
        case .CON:      return "코넌"
        case .SOFI:     return "라이파이낸스"
        case .GOM2:     return "고머니2"
        case .MVC:      return "마일벌스"
        case .VSYS:     return "브이시스템즈"
        case .GO:       return "고체인"
        case .WOZX:     return "이포스"
        case .WICC:     return "웨이키체인"
        case .EVZ:      return "이브이지"
        case .BUGGER:   return "버거스왑"
        case .SOC:      return "소다코인"
        case .GHX:      return "게이머코인"
        case .XNO:      return "제노토큰"
        case .EGG:      return "네스트리"
        case .IPX:      return "타키온프로토콜"
        case .VALOR:    return "밸러토큰"
        case .WOM:      return "왐토큰"
        case .WIKEN:    return "위드"
        case .RINGX:    return "링엑스"
        case .APM:      return "에이피엠 코인"
        case .TRV:      return "트러스트버스"
        case .BLY:      return "블로서리"
        case .ANW:      return "앵커뉴럴월드"
        case .APIX:     return "아픽스"
        case .POLA:     return "폴라리스 쉐어"
        case .PCI:      return "페이코인"
        case .TDROP:    return "티드랍"
        case .CTC:      return "크레딧코인"
        case .CWD:      return "크라우드"
        case .COLA:     return "콜라토큰"
        case .AWO:      return "에이아이워크"
        case .ADP:      return "어댑터 토큰"
        case .ANV:      return "애니버스"
        case .ARW:      return "아로와나토큰"
        case .SPRT:     return "스포티움"
        case .MM:       return "밀리미터토큰"
        case .ATOLO:    return "라이즌"
        }
    }
    
    init?(symbol: String) {
        switch symbol {
        case "BTC":
            self = .BTC
        case "ETH":
            self = .ETH
        case "BNB":
            self = .BNB
        case "XRP":
            self = .XRP
        case "LUNA":
            self = .LUNA
        case "SOL":
            self = .SOL
        case "ADA":
            self = .ADA
        case "DOT":
            self = .DOT
        case "DOGE":
            self = .DOGE
        case "MATIC":
            self = .MATIC
        case "CRO":
            self = .CRO
        case "DAI":
            self = .DAI
        case "ATOM":
            self = .ATOM
        case "LTC":
            self = .LTC
        case "LINK":
            self = .LINK
        case "UNI":
            self = .UNI
        case "TRX":
            self = .TRX
        case "BCH":
            self = .BCH
        case "ALGO":
            self = .ALGO
        case "MANA":
            self = .MANA
        case "XLM":
            self = .XLM
        case "ETC":
            self = .ETC
        case "SAND":
            self = .SAND
        case "AXS":
            self = .AXS
        case "VET":
            self = .VET
        case "EGLD":
            self = .EGLD
        case "THETA":
            self = .THETA
        case "KLAY":
            self = .KLAY
        case "XTZ":
            self = .XTZ
        case "EOS":
            self = .EOS
        case "AAVE":
            self = .AAVE
        case "MKR":
            self = .MKR
        case "WAVES":
            self = .WAVES
        case "CAKE":
            self = .CAKE
        case "GALA":
            self = .GALA
        case "GRT":
            self = .GRT
        case "BSV":
            self = .BSV
        case "ENJ":
            self = .ENJ
        case "CHZ":
            self = .CHZ
        case "KSM":
            self = .KSM
        case "BAT":
            self = .BAT
        case "LRC":
            self = .LRC
        case "XEM":
            self = .XEM
        case "TFUEL":
            self = .TFUEL
        case "XYM":
            self = .XYM
        case "BORA":
            self = .BORA
        case "COMP":
            self = .COMP
        case "YFI":
            self = .YFI
        case "WEMIX":
            self = .WEMIX
        case "QTUM":
            self = .QTUM
        case "BNT":
            self = .BNT
        case "WAXP":
            self = .WAXP
        case "ANKR":
            self = .ANKR
        case "OMG":
            self = .OMG
        case "UMA":
            self = .UMA
        case "LPT":
            self = .LPT
        case "BTG":
            self = .BTG
        case "RLY":
            self = .RLY
        case "ZIL":
            self = .ZIL
        case "ICX":
            self = .ICX
        case "ONT":
            self = .ONT
        case "ZRX":
            self = .ZRX
        case "NU":
            self = .NU
        case "SNX":
            self = .SNX
        case "WOO":
            self = .WOO
        case "IOST":
            self = .IOST
        case "GLM":
            self = .GLM
        case "SUSHI":
            self = .SUSHI
        case "HIVE":
            self = .HIVE
        case "UOS":
            self = .UOS
        case "JST":
            self = .JST
        case "CKB":
            self = .CKB
        case "REN":
            self = .REN
        case "OCEAN":
            self = .OCEAN
        case "CELR":
            self = .CELR
        case "C98":
            self = .C98
        case "KNC":
            self = .KNC
        case "SRM":
            self = .SRM
        case "SXP":
            self = .SXP
        case "POWR":
            self = .POWR
        case "CHR":
            self = .CHR
        case "COTI":
            self = .COTI
        case "ALICE":
            self = .ALICE
        case "FX":
            self = .FX
        case "MED":
            self = .MED
        case "ONG":
            self = .ONG
        case "CTSI":
            self = .CTSI
        case "ORBS":
            self = .ORBS
        case "PUNDIX":
            self = .PUNDIX
        case "BOBA":
            self = .BOBA
        case "MXC":
            self = .MXC
        case "SNT":
            self = .SNT
        case "RSR":
            self = .RSR
        case "ELF":
            self = .ELF
        case "BFC":
            self = .BFC
        case "NMR":
            self = .NMR
        case "ORC":
            self = .ORC
        case "OXT":
            self = .OXT
        case "REP":
            self = .REP
        case "DAO":
            self = .DAO
        case "RLC":
            self = .RLC
        case "STRAX":
            self = .STRAX
        case "GXC":
            self = .GXC
        case "STEEM":
            self = .STEEM
        case "CENNZ":
            self = .CENNZ
        case "META":
            self = .META
        case "SUN":
            self = .SUN
        case "XPR":
            self = .XPR
        case "BCD":
            self = .BCD
        case "XVS":
            self = .XVS
        case "SSX":
            self = .SSX
        case "BAKE":
            self = .BAKE
        case "QKC":
            self = .QKC
        case "MTL":
            self = .MTL
        case "VRA":
            self = .VRA
        case "MIR":
            self = .MIR
        case "ARPA":
            self = .ARPA
        case "BAL":
            self = .BAL
        case "CTK":
            self = .CTK
        case "LOOM":
            self = .LOOM
        case "AERGO":
            self = .AERGO
        case "AQT":
            self = .AQT
        case "LINA":
            self = .LINA
        case "MLK":
            self = .MLK
        case "DAD":
            self = .DAD
        case "ASM":
            self = .ASM
        case "COS":
            self = .COS
        case "BIOT":
            self = .BIOT
        case "MEV":
            self = .MEV
        case "VELO":
            self = .VELO
        case "MIX":
            self = .MIX
        case "CTXC":
            self = .CTXC
        case "FRONT":
            self = .FRONT
        case "CYCLUB":
            self = .CYCLUB
        case "BEL":
            self = .BEL
        case "AION":
            self = .AION
        case "MAP":
            self = .MAP
        case "FCT2":
            self = .FCT2
        case "WTC":
            self = .WTC
        case "BOA":
            self = .BOA
        case "CON":
            self = .CON
        case "SOFI":
            self = .SOFI
        case "GOM2":
            self = .GOM2
        case "MVC":
            self = .MVC
        case "VSYS":
            self = .VSYS
        case "GO":
            self = .GO
        case "WOZX":
            self = .WOZX
        case "WICC":
            self = .WICC
        case "EVZ":
            self = .EVZ
        case "BUGGER":
            self = .BUGGER
        case "SOC":
            self = .SOC
        case "GHX":
            self = .GHX
        case "XNO":
            self = .XNO
        case "EGG":
            self = .EGG
        case "IPX":
            self = .IPX
        case "VALOR":
            self = .VALOR
        case "WOM":
            self = .WOM
        case "WIKEN":
            self = .WIKEN
        case "RINGX":
            self = .RINGX
        case "APM":
            self = .APM
        case "TRV":
            self = .TRV
        case "BLY":
            self = .BLY
        case "ANW":
            self = .ANW
        case "APIX":
            self = .APIX
        case "POLA":
            self = .POLA
        case "PCI":
            self = .PCI
        case "TDROP":
            self = .TDROP
        case "CTC":
            self = .CTC
        case "CWD":
            self = .CWD
        case "COLA":
            self = .COLA
        case "AWO":
            self = .AWO
        case "ADP":
            self = .ADP
        case "ANV":
            self = .ANV
        case "ARW":
            self = .ARW
        case "SPRT":
            self = .SPRT
        case "MM":
            self = .MM
        case "ATOLO":
            self = .ATOLO
        default:
            return nil
        }
    }
}

//
//  Coin.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/01.
//

import Foundation

enum Coin: String, CaseIterable {
    case BTC
    case ETH
    case BNB
    case XRP
    case LUNA
    case SOL
    case ADA
    case DOT
    case DOGE
    case MATIC
    case CRO
    case DAI
    case ATOM
    case LTC
    case LINK
    case UNI
    case TRX
    case BCH
    case ALGO
    case MANA
    case XLM
    case ETC
    case SAND
    case AXS
    case VET
    case EGLD
    case THETA
    case KLAY
    case XTZ
    case EOS
    case AAVE
    case MKR
    case WAVES
    case CAKE
    case GALA
    case GRT
    case BSV
    case ENJ
    case CHZ
    case KSM
    case BAT
    case LRC
    case XEM
    case TFUEL
    case XYM
    case BORA
    case COMP
    case YFI
    case WEMIX
    case QTUM
    case BNT
    case WAXP
    case ANKR
    case OMG
    case UMA
    case LPT
    case BTG
    case RLY
    case ZIL
    case ICX
    case ONT
    case ZRX
    case NU
    case SNX
    case WOO
    case IOST
    case GLM
    case SUSHI
    case HIVE
    case UOS
    case JST
    case CKB
    case REN
    case OCEAN
    case CELR
    case C98
    case KNC
    case SRM
    case SXP
    case POWR
    case CHR
    case COTI
    case ALICE
    case FX
    case MED
    case ONG
    case CTSI
    case ORBS
    case PUNDIX
    case BOBA
    case MXC
    case SNT
    case RSR
    case ELF
    case BFC
    case NMR
    case ORC
    case OXT
    case REP
    case DAO
    case RLC
    case STRAX
    case GXC
    case STEEM
    case CENNZ
    case META
    case SUN
    case XPR
    case BCD
    case XVS
    case SSX
    case BAKE
    case QKC
    case MTL
    case VRA
    case MIR
    case ARPA
    case BAL
    case CTK
    case LOOM
    case AERGO
    case AQT
    case LINA
    case MLK
    case DAD
    case ASM
    case COS
    case BIOT
    case MEV
    case VELO
    case MIX
    case CTXC
    case FRONT
    case CYCLUB
    case BEL
    case AION
    case MAP
    case FCT2
    case WTC
    case BOA
    case CON
    case SOFI
    case GOM2
    case MVC
    case VSYS
    case GO
    case WOZX
    case WICC
    case EVZ
    case BUGGER
    case SOC
    case GHX
    case XNO
    case EGG
    case IPX
    case VALOR
    case WOM
    case WIKEN
    case RINGX
    case APM
    case TRV
    case BLY
    case ANW
    case APIX
    case POLA
    case PCI
    case TDROP
    case CTC
    case CWD
    case COLA
    case AWO
    case ADP
    case ANV
    case ARW
    case SPRT
    case MM
    case ATOLO
    
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
}

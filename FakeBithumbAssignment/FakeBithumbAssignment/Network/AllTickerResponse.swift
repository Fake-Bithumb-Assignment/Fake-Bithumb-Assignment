//
//  AllTickerResponse.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/04.
//

import Foundation

struct AllTickerResponse: Codable, Loopable {
    
    // MARK: - Instance Property
    
    let btc, eth, ltc, etc: Ticker
    let xrp, bch, qtum, btg: Ticker
    let eos, icx, trx, elf: Ticker
    let omg, knc, glm, zil: Ticker
    let waxp, powr, lrc, steem: Ticker
    let strax, zrx, rep, xem: Ticker
    let snt, ada, ctxc, bat: Ticker
    let wtc, theta, loom, waves: Ticker
    let link, enj, vet, mtl: Ticker
    let iost, tmtg, qkc, atolo: Ticker
    let amo, bsv, orbs, tfuel: Ticker
    let valor, con, ankr, mix: Ticker
    let cro, fx, chr, mbl: Ticker
    let mxc, fct2, trv, dad: Ticker
    let wom, soc, boa, mev: Ticker
    let sxp, cos, apix, el: Ticker
    let basic, hive, xpr, vra: Ticker
    let fit, egg, bora, arpa: Ticker
    let ctc, apm, ckb, aergo: Ticker
    let anw, cennz, evz, cyclub: Ticker
    let srm, qtcon, uni, yfi: Ticker
    let uma, aave, comp, ren: Ticker
    let bal, rsr, nmr, rlc: Ticker
    let uos, sand, gom2, ringx: Ticker
    let bel, obsr, orc, pola: Ticker
    let awo, adp, dvi, ghx: Ticker
    let mir, mvc, bly, wozx: Ticker
    let anv, grt, mm, biot: Ticker
    let xno, snx, sofi, cola: Ticker
    let nu, oxt, lina, map: Ticker
    let aqt, wiken, ctsi, mana: Ticker
    let lpt, mkr, sushi, asm: Ticker
    let pundix, celr, cwd, arw: Ticker
    let front, rly, ocean, bfc: Ticker
    let alice, coti, cake, bnt: Ticker
    let xvs, chz, axs, dao: Ticker
    let dai, matic, woo, bake: Ticker
    let velo, bcd, xlm, gxc: Ticker
    let vsys, ipx, wicc, ont: Ticker
    let luna, aion, meta, klay: Ticker
    let ong, algo, jst, xtz: Ticker
    let mlk, wemix, dot, atom: Ticker
    let ssx, temco, hibs, burger: Ticker
    let doge, ksm, ctk, xym: Ticker
    let bnb, nft, sun, xec: Ticker
    let pci, sol, egld, go: Ticker
    let c98, med, the1Inch, boba: Ticker
    let gala, btt, tdrop, sprt: Ticker
    let date: String

    enum CodingKeys: String, CodingKey {
        case btc = "BTC"
        case eth = "ETH"
        case ltc = "LTC"
        case etc = "ETC"
        case xrp = "XRP"
        case bch = "BCH"
        case qtum = "QTUM"
        case btg = "BTG"
        case eos = "EOS"
        case icx = "ICX"
        case trx = "TRX"
        case elf = "ELF"
        case omg = "OMG"
        case knc = "KNC"
        case glm = "GLM"
        case zil = "ZIL"
        case waxp = "WAXP"
        case powr = "POWR"
        case lrc = "LRC"
        case steem = "STEEM"
        case strax = "STRAX"
        case zrx = "ZRX"
        case rep = "REP"
        case xem = "XEM"
        case snt = "SNT"
        case ada = "ADA"
        case ctxc = "CTXC"
        case bat = "BAT"
        case wtc = "WTC"
        case theta = "THETA"
        case loom = "LOOM"
        case waves = "WAVES"
        case link = "LINK"
        case enj = "ENJ"
        case vet = "VET"
        case mtl = "MTL"
        case iost = "IOST"
        case tmtg = "TMTG"
        case qkc = "QKC"
        case atolo = "ATOLO"
        case amo = "AMO"
        case bsv = "BSV"
        case orbs = "ORBS"
        case tfuel = "TFUEL"
        case valor = "VALOR"
        case con = "CON"
        case ankr = "ANKR"
        case mix = "MIX"
        case cro = "CRO"
        case fx = "FX"
        case chr = "CHR"
        case mbl = "MBL"
        case mxc = "MXC"
        case fct2 = "FCT2"
        case trv = "TRV"
        case dad = "DAD"
        case wom = "WOM"
        case soc = "SOC"
        case boa = "BOA"
        case mev = "MEV"
        case sxp = "SXP"
        case cos = "COS"
        case apix = "APIX"
        case el = "EL"
        case basic = "BASIC"
        case hive = "HIVE"
        case xpr = "XPR"
        case vra = "VRA"
        case fit = "FIT"
        case egg = "EGG"
        case bora = "BORA"
        case arpa = "ARPA"
        case ctc = "CTC"
        case apm = "APM"
        case ckb = "CKB"
        case aergo = "AERGO"
        case anw = "ANW"
        case cennz = "CENNZ"
        case evz = "EVZ"
        case cyclub = "CYCLUB"
        case srm = "SRM"
        case qtcon = "QTCON"
        case uni = "UNI"
        case yfi = "YFI"
        case uma = "UMA"
        case aave = "AAVE"
        case comp = "COMP"
        case ren = "REN"
        case bal = "BAL"
        case rsr = "RSR"
        case nmr = "NMR"
        case rlc = "RLC"
        case uos = "UOS"
        case sand = "SAND"
        case gom2 = "GOM2"
        case ringx = "RINGX"
        case bel = "BEL"
        case obsr = "OBSR"
        case orc = "ORC"
        case pola = "POLA"
        case awo = "AWO"
        case adp = "ADP"
        case dvi = "DVI"
        case ghx = "GHX"
        case mir = "MIR"
        case mvc = "MVC"
        case bly = "BLY"
        case wozx = "WOZX"
        case anv = "ANV"
        case grt = "GRT"
        case mm = "MM"
        case biot = "BIOT"
        case xno = "XNO"
        case snx = "SNX"
        case sofi = "SOFI"
        case cola = "COLA"
        case nu = "NU"
        case oxt = "OXT"
        case lina = "LINA"
        case map = "MAP"
        case aqt = "AQT"
        case wiken = "WIKEN"
        case ctsi = "CTSI"
        case mana = "MANA"
        case lpt = "LPT"
        case mkr = "MKR"
        case sushi = "SUSHI"
        case asm = "ASM"
        case pundix = "PUNDIX"
        case celr = "CELR"
        case cwd = "CWD"
        case arw = "ARW"
        case front = "FRONT"
        case rly = "RLY"
        case ocean = "OCEAN"
        case bfc = "BFC"
        case alice = "ALICE"
        case coti = "COTI"
        case cake = "CAKE"
        case bnt = "BNT"
        case xvs = "XVS"
        case chz = "CHZ"
        case axs = "AXS"
        case dao = "DAO"
        case dai = "DAI"
        case matic = "MATIC"
        case woo = "WOO"
        case bake = "BAKE"
        case velo = "VELO"
        case bcd = "BCD"
        case xlm = "XLM"
        case gxc = "GXC"
        case vsys = "VSYS"
        case ipx = "IPX"
        case wicc = "WICC"
        case ont = "ONT"
        case luna = "LUNA"
        case aion = "AION"
        case meta = "META"
        case klay = "KLAY"
        case ong = "ONG"
        case algo = "ALGO"
        case jst = "JST"
        case xtz = "XTZ"
        case mlk = "MLK"
        case wemix = "WEMIX"
        case dot = "DOT"
        case atom = "ATOM"
        case ssx = "SSX"
        case temco = "TEMCO"
        case hibs = "HIBS"
        case burger = "BURGER"
        case doge = "DOGE"
        case ksm = "KSM"
        case ctk = "CTK"
        case xym = "XYM"
        case bnb = "BNB"
        case nft = "NFT"
        case sun = "SUN"
        case xec = "XEC"
        case pci = "PCI"
        case sol = "SOL"
        case egld = "EGLD"
        case go = "GO"
        case c98 = "C98"
        case med = "MED"
        case the1Inch = "1INCH"
        case boba = "BOBA"
        case gala = "GALA"
        case btt = "BTT"
        case tdrop = "TDROP"
        case sprt = "SPRT"
        case date
    }
    
    struct Ticker: Codable {
        let openingPrice, closingPrice, minPrice, maxPrice: String
        let unitsTraded, accTradeValue, prevClosingPrice, unitsTraded24H: String
        let accTradeValue24H, fluctate24H, fluctateRate24H: String

        enum CodingKeys: String, CodingKey {
            case openingPrice = "opening_price"
            case closingPrice = "closing_price"
            case minPrice = "min_price"
            case maxPrice = "max_price"
            case unitsTraded = "units_traded"
            case accTradeValue = "acc_trade_value"
            case prevClosingPrice = "prev_closing_price"
            case unitsTraded24H = "units_traded_24H"
            case accTradeValue24H = "acc_trade_value_24H"
            case fluctate24H = "fluctate_24H"
            case fluctateRate24H = "fluctate_rate_24H"
        }
    }
}



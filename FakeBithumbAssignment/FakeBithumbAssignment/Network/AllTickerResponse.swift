//
//  AllTickerResponse.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/04.
//

import Foundation

struct AllTickerResponse: Codable, Loopable {
    let btc, eth, ltc, etc: Item
    let xrp, bch, qtum, btg: Item
    let eos, icx, trx, elf: Item
    let omg, knc, glm, zil: Item
    let waxp, powr, lrc, steem: Item
    let strax, zrx, rep, xem: Item
    let snt, ada, ctxc, bat: Item
    let wtc, theta, loom, waves: Item
    let link, enj, vet, mtl: Item
    let iost, tmtg, qkc, atolo: Item
    let amo, bsv, orbs, tfuel: Item
    let valor, con, ankr, mix: Item
    let cro, fx, chr, mbl: Item
    let mxc, fct2, trv, dad: Item
    let wom, soc, boa, mev: Item
    let sxp, cos, apix, el: Item
    let basic, hive, xpr, vra: Item
    let fit, egg, bora, arpa: Item
    let ctc, apm, ckb, aergo: Item
    let anw, cennz, evz, cyclub: Item
    let srm, qtcon, uni, yfi: Item
    let uma, aave, comp, ren: Item
    let bal, rsr, nmr, rlc: Item
    let uos, sand, gom2, ringx: Item
    let bel, obsr, orc, pola: Item
    let awo, adp, dvi, ghx: Item
    let mir, mvc, bly, wozx: Item
    let anv, grt, mm, biot: Item
    let xno, snx, sofi, cola: Item
    let nu, oxt, lina, map: Item
    let aqt, wiken, ctsi, mana: Item
    let lpt, mkr, sushi, asm: Item
    let pundix, celr, cwd, arw: Item
    let front, rly, ocean, bfc: Item
    let alice, coti, cake, bnt: Item
    let xvs, chz, axs, dao: Item
    let dai, matic, woo, bake: Item
    let velo, bcd, xlm, gxc: Item
    let vsys, ipx, wicc, ont: Item
    let luna, aion, meta, klay: Item
    let ong, algo, jst, xtz: Item
    let mlk, wemix, dot, atom: Item
    let ssx, temco, hibs, burger: Item
    let doge, ksm, ctk, xym: Item
    let bnb, nft, sun, xec: Item
    let pci, sol, egld, go: Item
    let c98, med, the1Inch, boba: Item
    let gala, btt, tdrop, sprt: Item
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
}

struct Item: Codable {
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


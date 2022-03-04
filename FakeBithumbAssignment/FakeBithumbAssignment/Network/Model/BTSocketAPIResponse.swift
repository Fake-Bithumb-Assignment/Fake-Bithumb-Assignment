//
//  WebSocketApiResponse.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/23.
//

import Foundation

import Then

/// 빗썸 Web Socket API Response 응답
struct BTSocketAPIResponse {
    enum BTSocketAPIResponseError: Error {
        case canNotParse
    }
    
    /// 구독 메시지 종류
    enum ResponseType: String, Decodable {
        /// 현재가
        case ticker = "ticker"
        /// 체결
        case transaction = "transaction"
        /// 호가
        case orderBook  = "orderbookdepth"
    }
        
    /// tick 종류
    enum TickType: String, Decodable {
        case _30m = "30M"
        case _1h = "1H"
        case _12h = "12H"
        case _24h = "24H"
        case mid = "MID"
    }
    
    /// Ticker API 응답
    struct TickerResponse: Decodable {
        /// WebSocket API type
        let type: ResponseType
        /// Ticker 응답의 유의미한 값
        let content: Ticker
        
        /// Ticker 응답의 유의미한 값
        struct Ticker: Decodable {
            /// 통화 코드
            let symbol: String
            /// 변동 기준시간- 30M, 1H, 12H, 24H, MID
            let tickType: TickType
            /// 일자
            let date: Int
            /// 시간
            let time: Int
            /// 시가
            let openPrice: Double
            /// 종가
            let closePrice: Double
            /// 저가
            let lowPrice: Double
            /// 고가
            let highPrice: Double
            /// 누적거래금액
            let value: Double
            /// 누적거래량
            let volume: Double
            /// 매도누적거래량
            let sellVolume: Double
            /// 매수누적거래량
            let buyVolume: Double
            /// 전일종가
            let prevClosePrice: Double
            /// 변동률
            let chgRate: Double
            /// 변동금액
            let chgAmt: Double
            /// 체결강도
            let volumePower: Double
            
            enum CodingKeys: String, CodingKey {
                case symbol, tickType, date, time, openPrice, closePrice, lowPrice, highPrice
                case value, volume, sellVolume, buyVolume, prevClosePrice, chgRate, chgAmt, volumePower
            }
                        
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                self.symbol = try values.decode(String.self, forKey: .symbol)
                self.tickType = try values.decode(TickType.self, forKey: .tickType)
                guard let date = Int(try values.decode(String.self, forKey: .date)),
                      let time = Int(try values.decode(String.self, forKey: .time)),
                      let openPrice = Double(try values.decode(String.self, forKey: .openPrice)),
                      let closePrice = Double(try values.decode(String.self, forKey: .closePrice)),
                      let lowPrice = Double(try values.decode(String.self, forKey: .lowPrice)),
                      let highPrice = Double(try values.decode(String.self, forKey: .highPrice)),
                      let value = Double(try values.decode(String.self, forKey: .value)),
                      let volume = Double(try values.decode(String.self, forKey: .volume)),
                      let sellVolume = Double(try values.decode(String.self, forKey: .sellVolume)),
                      let buyVolume = Double(try values.decode(String.self, forKey: .buyVolume)),
                      let prevClosePrice = Double(try values.decode(String.self, forKey: .prevClosePrice)),
                      let chgRate = Double(try values.decode(String.self, forKey: .chgRate)),
                      let chgAmt = Double(try values.decode(String.self, forKey: .chgAmt)),
                      let volumePower = Double(try values.decode(String.self, forKey: .volumePower))
                else {
                    throw BTSocketAPIResponseError.canNotParse
                }
                self.date = date
                self.time = time
                self.openPrice = openPrice
                self.closePrice = closePrice
                self.lowPrice = lowPrice
                self.highPrice = highPrice
                self.value = value
                self.volume = volume
                self.sellVolume = sellVolume
                self.buyVolume = buyVolume
                self.prevClosePrice = prevClosePrice
                self.chgRate = chgRate
                self.chgAmt = chgAmt
                self.volumePower = volumePower
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case type, content
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try values.decode(ResponseType.self, forKey: .type)
            self.content = try values.decode(Ticker.self, forKey: .content)
        }
    }
    
    /// Transaction API 응답
    struct TransactionResponse: Decodable {
        /// WebSocket API type
        let type: ResponseType
        /// Transaction API의 유의미한 값
        let content: Content
        
        /// Transaction API의 유의미한 값
        struct Content: Decodable {
            /// 체결 이력
            let list: [Transaction]
            
            /// 체결
            struct Transaction: Decodable {
                /// 통화코드
                let symbol: String
                /// 체결종류
                let buySellGb: BuyCell
                /// 체결가격
                let contPrice: Double
                /// 체결수량
                let contQty: Double
                /// 체결금액
                let contAmt: Double
                /// 체결시각
                let contDtm: Date
                /// 직전시세와 비교
                let updn: UpDown
                
                /// 체결종류
                enum BuyCell: String, Decodable {
                    /// 매도체결
                    case sell = "1"
                    /// 매수체결
                    case buy = "2"
                }
                
                /// 직전시세와 비교
                enum UpDown: String, Decodable {
                    /// 상승
                    case up = "up"
                    /// 하락
                    case down = "dn"
                }
                
                enum CodingKeys: String, CodingKey {
                    case symbol, buySellGb, contPrice, contQty, contAmt, contDtm, updn
                }
                
                static let dateFormatter = DateFormatter().then {
                    $0.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
                }
                
                init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: CodingKeys.self)
                    self.symbol = try values.decode(String.self, forKey: .symbol)
                    self.buySellGb = try values.decode(BuyCell.self, forKey: .buySellGb)
                    self.updn = try values.decode(UpDown.self, forKey: .updn)
                    guard let contPrice = Double(try values.decode(String.self, forKey: .contPrice)),
                          let contQty = Double(try values.decode(String.self, forKey: .contQty)),
                          let contAmt = Double(try values.decode(String.self, forKey: .contAmt)),
                          let contDtm = Transaction.dateFormatter.date(
                            from: try values.decode(String.self, forKey: .contDtm)
                          )
                    else {
                        throw BTSocketAPIResponseError.canNotParse
                    }
                    self.contPrice = contPrice
                    self.contQty = contQty
                    self.contAmt = contAmt
                    self.contDtm = contDtm
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case list
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                self.list = try values.decode([Transaction].self, forKey: .list)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case type, content
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            type = try values.decode(ResponseType.self, forKey: .type)
            content = try values.decode(Content.self, forKey: .content)
        }
    }
    
    /// OrderBook API 응답
    struct OrderBookResponse: Decodable {
        /// WebSocket API type
        let type: ResponseType
        /// OrderBook API의 유의미한 값
        let content: Content
        
        /// OrderBook API의 유의미한 값
        struct Content: Decodable {
            /// 호가 이력
            let list: [OrderBook]
            /// 일시
            let datetime: Int
            
            /// 호가
            struct OrderBook: Decodable {
                /// 통화코드
                let symbol: String
                /// 주문 타입
                let orderType: OrderType
                /// 호가
                let price: Double
                /// 잔량
                let quantity: Double
                /// 건수
                let total: Int
                
                /// 주문 타입
                enum OrderType: String, Decodable {
                    /// 매도
                    case ask = "ask"
                    /// 매수
                    case bid = "bid"
                }
                
                enum CodingKeys: String, CodingKey {
                    case symbol, orderType, price, quantity, total
                }
                
                init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: CodingKeys.self)
                    self.symbol = try values.decode(String.self, forKey: .symbol)
                    self.orderType = try values.decode(OrderType.self, forKey: .orderType)
                    guard let price = Double(try values.decode(String.self, forKey: .price)),
                          let quantity = Double(try values.decode(String.self, forKey: .quantity)),
                          let total = Int(try values.decode(String.self, forKey: .price))
                    else {
                        throw BTSocketAPIResponseError.canNotParse
                    }
                    self.price = price
                    self.quantity = quantity
                    self.total = total
                }

            }
            
            enum CodingKeys: String, CodingKey {
                case list, datetime
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                self.list = try values.decode([OrderBook].self, forKey: .list)
                guard let datetime = Int(try values.decode(String.self, forKey: .datetime)) else {
                    throw BTSocketAPIResponseError.canNotParse
                }
                self.datetime = datetime
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case type, content
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try values.decode(ResponseType.self, forKey: .type)
            self.content = try values.decode(Content.self, forKey: .content)
        }
    }
}

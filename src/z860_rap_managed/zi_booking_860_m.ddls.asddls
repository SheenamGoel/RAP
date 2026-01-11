@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking view Entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_Booking_860_M as select from z860_booking_m
association to parent ZI_TRAVEL_860_M as _Travel on $projection.TravelId = _Travel.TravelId
composition [0..*] of ZI_BOOKSUP_860_M as _BookingSupplement
association [1..1] to /DMO/I_Carrier as _Carrier on $projection.CarrierId = _Carrier.AirlineID
association [1..1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID
association [1..1] to /DMO/I_Connection as _Connection on $projection.ConnectionId = _Connection.ConnectionID and $projection.CarrierId = _Connection.AirlineID
association [1..1] to /DMO/I_Booking_Status_VH as _BookingStatus on $projection.BookingStatus = _BookingStatus.BookingStatus
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    booking_date as BookingDate,
    customer_id as CustomerId,
    carrier_id as CarrierId,
    connection_id as ConnectionId,
    flight_date as FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    flight_price as FlightPrice,
    currency_code as CurrencyCode,
    booking_status as BookingStatus,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    //      Annotations-->
    _Travel,
    _BookingSupplement,
    _Carrier,
    _Customer,
    _Connection,
    _BookingStatus
    
}

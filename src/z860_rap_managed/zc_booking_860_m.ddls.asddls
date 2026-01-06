@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Projection View'
@Metadata.allowExtensions: true
define view entity ZC_Booking_860_M as projection on ZI_Booking_860_M
{
    key TravelId,
    key BookingId,
    BookingDate,
    @ObjectModel.text.element: [ 'CustomerName' ]
    CustomerId,
    _Customer.LastName as CustomerName,
    @ObjectModel.text.element: [ 'AirlineID' ]
    CarrierId,
    _Carrier.AirlineID as AirlineID,
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    @ObjectModel.text.element: [ 'BookingStatusText' ]
    BookingStatus,
    _BookingStatus._Text.Text as BookingStatusText : localized,
    LastChangedAt,
    /* Associations */
    _BookingStatus,
    _BookingSupplement: redirected to composition child ZC_Booksup_860_m,
    _Carrier,
    _Connection,
    _Customer,
    _Travel: redirected to parent ZC_Travel_860_M
}

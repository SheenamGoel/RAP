@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplement Entity View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKSUP_860_M as select from z860_booksup_m
association to parent ZI_Booking_860_M as _Booking on $projection.TravelId = _Booking.TravelId and $projection.BookingId = _Booking.BookingId
association [1..1] to ZI_TRAVEL_860_M as _Travel on $projection.TravelId = _Travel.TravelId
association [1..1] to /DMO/I_Supplement as _BookingSupplement on $projection.BookingSupplementId = _BookingSupplement.SupplementID
association [1..*] to /DMO/I_SupplementText as _SupplementText on $projection.BookingSupplementId = _SupplementText.SupplementID
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    //      Annotations-->
    _Booking,
    _Travel,
    _BookingSupplement,
    _SupplementText
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplement Projection view'
@Metadata.allowExtensions: true
define view entity ZC_Booksup_860_m as projection on ZI_BOOKSUP_860_M
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    @ObjectModel.text.element: [ 'SupplementDescription' ]
    SupplementId,
    _SupplementText.Description as SupplementDescription : localized,
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking: redirected to parent ZC_Booking_860_M,
    _BookingSupplement,
    _SupplementText,
    _Travel: redirected to ZC_Travel_860_M
}

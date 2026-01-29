@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel projection view'
@Metadata.allowExtensions: true
define root view entity ZC_Travel_860_M
  provider contract transactional_query
  as projection on ZI_TRAVEL_860_M

{
  key TravelId,
      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyId,
      _Agency.Name       as AgencyName,
      @ObjectModel.text.element: [ 'LastName' ]
      CustomerId,
      _Customer.LastName as LastName,
      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,
      CurrencyCode,
      Description,
      @ObjectModel.text.element: [ 'OverallStausText' ]
      OverallStatus,
      _Status._Text.Text as OverallStausText : localized,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      /* Associations */
      _Agency,
      _Booking : redirected to composition child ZC_Booking_860_M,
      _Currency,
      _Customer,
      _Status
}

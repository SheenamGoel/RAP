CLASS zcl_860_read_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_860_READ_PRACTICE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
********************************  Short form read  ********************************************************
*    READ ENTITY zi_travel_860_m FROM VALUE #( ( %key-TravelId = '00004110'
*                                                %control  = VALUE #( AgencyId = if_abap_behv=>mk-on
*                                                                     CustomerId = if_abap_behv=>mk-on
*                                                                     BeginDate = if_abap_behv=>mk-on )
*     ) )
*    RESULT DATA(lt_result_short)
*    FAILED DATA(lt_failed_short).
*
*    IF lt_failed_short IS NOT INITIAL.
*      out->write( 'Failed' ).
*    ELSE.
*      out->write( lt_result_short ).
*    ENDIF.

********************************  Short form read(Variant 2)  ********************************************************
*    READ ENTITY zi_travel_860_m
*    by \_Booking   "If we want to fetch data for association
**    FIELDS ( AgencyId CustomerID Begindate ) "For specific field
*    All Fields "For all fields
*    WITH VALUE #( ( %key-TravelId = '00004110'
*     ) )
*    RESULT DATA(lt_result_short)
*    FAILED DATA(lt_failed_short).
*
*    IF lt_failed_short IS NOT INITIAL.
*      out->write( 'Failed' ).
*    ELSE.
*      out->write( lt_result_short ).
*    ENDIF.

********************************  Long form read  ********************************************************
*Read ENTITIES OF zi_travel_860_m
*
*ENTITY zi_travel_860_m
*ALL FIELDS WITH VALUE #( ( %key-TravelId = '00004110' )
*                         ( %key-TravelId = '00004111' )
*      )
*    RESULT DATA(lt_result_long_travel)
*
*ENTITY zi_booking_860_m
*ALL FIELDS WITH VALUE #( ( %key-TravelId = '00004110' %key-BookingId = '001' ) )
*    RESULT DATA(lt_result_long_booking)
*    FAILED DATA(lt_failed_short).
*
*    IF lt_failed_short IS NOT INITIAL.
*      out->write( 'Failed' ).
*    ELSE.
*      out->write( lt_result_long_travel ).
*      out->write( lt_result_long_booking ).
*    ENDIF.

********************************  Dynamic form read  ********************************************************

    DATA: lt_optab              TYPE abp_behv_retrievals_tab,
          lt_travel_860_m       TYPE TABLE FOR READ IMPORT zi_travel_860_m,
          lt_result_tab         TYPE TABLE FOR READ RESULT zi_travel_860_m,
          lt_booking_860_m      TYPE TABLE FOR READ IMPORT zi_travel_860_m\_Booking,
          lt_booking_result_tab TYPE TABLE FOR READ RESULT zi_travel_860_m\_Booking.

    lt_travel_860_m = VALUE #( ( %key-TravelId = '00004110'
                                 %control  = VALUE #( AgencyId = if_abap_behv=>mk-on
                                                      CustomerId = if_abap_behv=>mk-on
                                                      BeginDate = if_abap_behv=>mk-on )
   ) ).

    lt_booking_860_m = VALUE #( ( %key-TravelId = '00004110'
                                  %control  = VALUE #( BookingDate = if_abap_behv=>mk-on
                                                       BookingId = if_abap_behv=>mk-on
                                                       BookingStatus = if_abap_behv=>mk-on )
    ) ).



    lt_optab = VALUE #( ( op = if_abap_behv=>op-r-read
                          entity_name = 'ZI_TRAVEL_860_M'
                          instances = REF #( lt_travel_860_m )
                          results = REF #( lt_result_tab ) )
                          ( op = if_abap_behv=>op-r-read_ba
                          entity_name = 'ZI_TRAVEL_860_M'
                          sub_name = '_BOOKING'
                          instances = REF #( lt_booking_860_m )
                          results = REF #( lt_booking_result_tab )
                          ) ).

    READ ENTITIES OPERATIONS lt_optab
    FAILED DATA(lt_failed_dynamic).

    IF lt_failed_dynamic IS NOT INITIAL.
      out->write( 'Failed' ).
    ELSE.
      out->write( lt_result_tab ).
      out->write( lt_booking_result_tab ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.

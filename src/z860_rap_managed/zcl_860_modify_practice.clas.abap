CLASS zcl_860_modify_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_860_MODIFY_PRACTICE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_booking TYPE TABLE FOR CREATE zi_travel_860_m\_Booking.

    MODIFY ENTITY zi_travel_860_m CREATE FROM VALUE #( (
    %cid = 'cid1'
    %data-BeginDate = '20260124'
    %control-BeginDate = if_abap_behv=>mk-on
     ) )
     CREATE BY \_Booking FROM VALUE #( (
      %cid_ref = 'cid1'
      %target = VALUE #( (
      %cid = 'cid11'
      bookingdate = '20260124'
      %control-BookingDate = if_abap_behv=>mk-on
       ) )

      ) )
     FAILED FINAL(it_failed)
     MAPPED FINAL(it_mapped)
     REPORTED FINAL(it_reported).

    IF it_failed IS NOT INITIAL.
      out->write( it_failed ).
    ELSE.
      COMMIT ENTITIES.
    ENDIF.

*******************2nd Form ( Recommended )
    MODIFY ENTITY zi_travel_860_m UPDATE FIELDS ( BeginDate ) WITH VALUE #( ( %key-TravelId = '00004344'
                                                BeginDate = '20260123' ) ).
    COMMIT ENTITIES.

*******************3rd Form (Not recommended- Performance issue
    MODIFY ENTITY zi_travel_860_m UPDATE SET FIELDS WITH VALUE #( ( %key-TravelId = '00004344'
                                                    BeginDate = '20260123' ) ).
    COMMIT ENTITIES.

  ENDMETHOD.
ENDCLASS.

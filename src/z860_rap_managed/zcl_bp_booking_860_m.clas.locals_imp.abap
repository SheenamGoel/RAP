CLASS lhc_zi_booking_860_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE ZI_Booking_860_M\_Bookingsupplement.

ENDCLASS.

CLASS lhc_zi_booking_860_m IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.

    DATA: lv_booksup_max TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_booking_860_m BY \_BookingSupplement FROM CORRESPONDING #( entities )
    LINK DATA(booking_supplements).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY <booking_group>-%tky.
      lv_booksup_max = REDUCE #( INIT lv_max = CONV /dmo/booking_supplement_id( '0' )
                                 FOR ls_booksup IN booking_supplements USING KEY entity
                                 WHERE ( source-TravelId = <booking_group>-TravelId AND source-BookingId = <booking_group>-BookingId )
                                 NEXT lv_max = COND /dmo/booking_supplement_id( WHEN lv_max < ls_booksup-target-BookingSupplementId
                                                                     THEN ls_booksup-target-BookingSupplementId
                                                                     ELSE lv_max ) ).

      lv_booksup_max = REDUCE #( INIT lv_max = lv_booksup_max
                                 FOR entity IN entities USING KEY entity
                                 WHERE ( TravelId = <booking_group>-TravelId AND BookingId = <booking_group>-BookingId )
                                 FOR target IN entity-%target
                                 NEXT lv_max = COND /dmo/booking_supplement_id( WHEN lv_max < target-BookingSupplementId
                                                                      THEN target-BookingSupplementId
                                                                      ELSE lv_max ) ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>) USING KEY entity WHERE TravelId = <booking_group>-travelid AND BookingId = <booking_group>-BookingId.


        LOOP AT <booking>-%target ASSIGNING FIELD-SYMBOL(<ls_bookingSupp>).
          APPEND CORRESPONDING #( <ls_bookingSupp> ) TO mapped-zi_booksup_860_m ASSIGNING FIELD-SYMBOL(<mapped_booking_supplement>).
          IF <mapped_booking_supplement>-BookingSupplementId IS INITIAL.
            lv_booksup_max += 1.
            <mapped_booking_supplement>-BookingSupplementId = lv_booksup_max.
          ENDIF.
        ENDLOOP.

      ENDLOOP.
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

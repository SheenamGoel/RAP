CLASS lhc_zi_booksup_860_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS totalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_booksup_860_m~totalPrice.

ENDCLASS.

CLASS lhc_zi_booksup_860_m IMPLEMENTATION.

  METHOD totalPrice.
    DATA: it_data TYPE STANDARD TABLE OF zi_travel_860_m WITH UNIQUE HASHED KEY key COMPONENTS TravelId.

    it_data = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING TravelId = TravelId ).
    MODIFY ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m
    EXECUTE recalTotalPrice
    FROM CORRESPONDING #( it_data ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

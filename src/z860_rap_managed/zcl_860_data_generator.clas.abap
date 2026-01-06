CLASS zcl_860_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
      INTERFACES:

      if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_860_data_generator IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.



    " delete existing entries in the database table

    DELETE FROM z860_travel_m.

    DELETE FROM z860_booking_m.

    DELETE FROM z860_booksup_m.

    COMMIT WORK.

    " insert travel demo data

    INSERT z860_travel_m FROM (

        SELECT *

          FROM /dmo/travel_m

      ).

    COMMIT WORK.



    " insert booking demo data

    INSERT z860_booking_m FROM (

        SELECT *

          FROM   /dmo/booking_m
      ).

    COMMIT WORK.

    INSERT z860_booksup_m FROM (

        SELECT *

          FROM   /dmo/booksuppl_m
      ).

    COMMIT WORK.



    out->write( 'Travel and booking demo data inserted.' ).
endmethod.
ENDCLASS.

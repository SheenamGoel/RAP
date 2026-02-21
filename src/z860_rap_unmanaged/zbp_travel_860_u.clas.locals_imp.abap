CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ Travel RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Travel.

    METHODS rba_Booking FOR READ
      IMPORTING keys_rba FOR READ Travel\_Booking FULL result_requested RESULT result LINK association_links.

    METHODS cba_Booking FOR MODIFY
      IMPORTING entities_cba FOR CREATE Travel\_Booking.

    TYPES: tt_failed   TYPE TABLE FOR FAILED EARLY zi_travel_860_u\\travel,
           tt_reported TYPE TABLE FOR REPORTED EARLY zi_travel_860_u\\travel.

    METHODS map_messages
      IMPORTING
        cid          TYPE abp_behv_cid
        messages     TYPE /dmo/t_message
      EXPORTING
        failed_added TYPE abap_boolean
      CHANGING
        failed       TYPE tt_failed
        reported     TYPE tt_reported.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

    DATA ls_travel_in TYPE /dmo/travel.
    DATA: ls_travel_out TYPE /dmo/travel,
          lt_messages   TYPE /dmo/t_message.


    LOOP AT entities INTO DATA(ls_entities).

      ls_travel_in = CORRESPONDING #( ls_entities MAPPING FROM ENTITY USING CONTROL ).
      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_CREATE'
        EXPORTING
          is_travel         = CORRESPONDING /dmo/s_travel_in( ls_travel_in )
*         it_booking        =
*         it_booking_supplement =
          iv_numbering_mode = /dmo/if_flight_legacy=>numbering_mode-late
        IMPORTING
          es_travel         = ls_travel_out
*         et_booking        =
*         et_booking_supplement =
          et_messages       = lt_messages.

      map_messages(
      EXPORTING
        cid =  ls_entities-%cid
        messages = lt_messages
      IMPORTING
        failed_added = DATA(lv_failed_added)
      CHANGING
        failed = failed-travel
        reported = reported-travel
      ).
      IF lv_failed_added = abap_false.
        INSERT VALUE #( %cid = ls_entities-%cid
        TravelID = ls_travel_out-travel_id ) INTO TABLE mapped-travel.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Booking.
  ENDMETHOD.

  METHOD cba_Booking.
  ENDMETHOD.


  METHOD map_messages.
    failed_added = abap_false.
    LOOP AT messages INTO DATA(ls_messages).
      IF ls_messages-msgty = 'E' OR ls_messages-msgty = 'A'.
        APPEND VALUE #( %cid = cid
                            %fail-cause = zcl_travel_860_aux=>get_cause_from_message(
                                            msgid        = ls_messages-msgid
                                            msgno        = ls_messages-msgno
*                                            is_dependent = abap_false
                                          )
                      ) TO failed.


        failed_added = abap_true.

        reported = VALUE #( ( %cid = cid
                              %msg = new_message(
                                       id       = ls_messages-msgid
                                       number   = ls_messages-msgno
                                       severity = if_abap_behv_message=>severity-error
                                       v1       = ls_messages-msgv1
                                       v2       = ls_messages-msgv2
                                       v3       = ls_messages-msgv3
                                       v4       = ls_messages-msgv4
                                     )
                            ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

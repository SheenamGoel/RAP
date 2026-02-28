CLASS lsc_zi_travel_860_m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_travel_860_m IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_travel_log   TYPE STANDARD TABLE OF zlog_travel_860,
          lt_travel_log_c TYPE STANDARD TABLE OF zlog_travel_860.

    IF create-zi_travel_860_m IS NOT INITIAL.

      lt_travel_log = CORRESPONDING #( create-zi_travel_860_m ).

      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_log>).
        <ls_travel_log>-changing_operation = 'CREATE'.
        GET TIME STAMP FIELD <ls_travel_log>-created_at.
        READ TABLE create-zi_travel_860_m ASSIGNING FIELD-SYMBOL(<ls_travel>) WITH TABLE KEY entity
                                                    COMPONENTS TravelId = <ls_travel_log>-travelid.

        IF sy-subrc = 0.

          IF <ls_travel>-%control-BookingFee = cl_abap_behv=>flag_changed.
            <ls_travel_log>-changed_fieldname = 'Booking Fee'.
            <ls_travel_log>-changed_value = <ls_travel>-BookingFee.
            TRY.
                <ls_travel_log>-chnage_id = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.

            APPEND <ls_travel_log> TO lt_travel_log_c.

          ENDIF.
          IF <ls_travel>-%control-OverallStatus = cl_abap_behv=>flag_changed.
            <ls_travel_log>-changed_fieldname = 'Overall status'.
            <ls_travel_log>-changed_value = <ls_travel>-OverallStatus.
            TRY.
                <ls_travel_log>-chnage_id = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.

            APPEND <ls_travel_log> TO lt_travel_log_c.

          ENDIF.
        ENDIF.

      ENDLOOP.
      INSERT zlog_travel_860 FROM TABLE @lt_travel_log_c.
    ENDIF.
    IF update-zi_travel_860_m IS NOT INITIAL.

      lt_travel_log = CORRESPONDING #( update-zi_travel_860_m ).

      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_update>).
        <ls_travel_update>-changing_operation = 'UPDATE'.
        GET TIME STAMP FIELD <ls_travel_update>-created_at.
        READ TABLE create-zi_travel_860_m ASSIGNING FIELD-SYMBOL(<ls_travel_upd>) WITH TABLE KEY entity
                                                    COMPONENTS TravelId = <ls_travel_update>-travelid.

        IF sy-subrc = 0.

          IF <ls_travel_upd>-%control-CustomerId = if_abap_behv=>mk-on.
            <ls_travel_update>-changed_fieldname = 'BCustomer ID'.
            <ls_travel_update>-changed_value = <ls_travel_upd>-CustomerId.
            TRY.
                <ls_travel_update>-chnage_id = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.

            APPEND <ls_travel_update> TO lt_travel_log_c.

          ENDIF.
          IF <ls_travel_upd>-%control-Description =  if_abap_behv=>mk-on.
            <ls_travel_update>-changed_fieldname = 'Description'.
            <ls_travel_update>-changed_value = <ls_travel_upd>-Description.
            TRY.
                <ls_travel_update>-chnage_id = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.

            APPEND <ls_travel_update> TO lt_travel_log_c.

          ENDIF.
        ENDIF.
      ENDLOOP.
      INSERT zlog_travel_860 FROM TABLE @lt_travel_log_c.
    ENDIF.
    IF delete-zi_travel_860_m IS NOT INITIAL.

      lt_travel_log = CORRESPONDING #( update-zi_travel_860_m ).
      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_delete>).
        <ls_travel_delete>-changing_operation = 'UPDATE'.
        GET TIME STAMP FIELD <ls_travel_update>-created_at.
        TRY.
            <ls_travel_update>-chnage_id = cl_system_uuid=>create_uuid_x16_static(  ).
          CATCH cx_uuid_error.
            "handle exception
        ENDTRY.

      ENDLOOP.
      INSERT zlog_travel_860 FROM TABLE @lt_travel_log_c.
    ENDIF.

********************************Booking Supplement unmanaged save*************************************
******************************************************************************************************

    DATA: lt_book_suppl TYPE STANDARD TABLE OF z860_booksup_m.

    IF create-zi_booksup_860_m IS INITIAL.
      lt_book_suppl = VALUE #( FOR ls_create IN create-zi_booksup_860_m (
                                        travel_id = ls_create-TravelId
                                        booking_id = ls_create-BookingId
                                        booking_supplement_id = ls_create-BookingSupplementId
                                        supplement_id = ls_create-SupplementId
                                        price = ls_create-Price
                                        currency_code = ls_create-CurrencyCode
                                        last_changed_at = ls_create-LastChangedAt
                            ) ).

      INSERT z860_booksup_m FROM TABLE @lt_book_suppl.
    ENDIF.

    IF update-zi_booksup_860_m IS INITIAL.
      lt_book_suppl = VALUE #( FOR ls_create IN update-zi_booksup_860_m (
                                  travel_id = ls_create-TravelId
                                  booking_id = ls_create-BookingId
                                  booking_supplement_id = ls_create-BookingSupplementId
                                  supplement_id = ls_create-SupplementId
                                  price = ls_create-Price
                                  currency_code = ls_create-CurrencyCode
                                  last_changed_at = ls_create-LastChangedAt
                      ) ).

      UPDATE z860_booksup_m FROM TABLE @lt_book_suppl.
    ENDIF.
    IF delete-zi_booksup_860_m IS INITIAL.
      lt_book_suppl = VALUE #( FOR ls_delete IN delete-zi_booksup_860_m (
                            travel_id = ls_delete-TravelId
                            booking_id = ls_delete-BookingId
                            booking_supplement_id = ls_delete-BookingSupplementId
                             ) ).

      DELETE z860_booksup_m FROM TABLE @lt_book_suppl.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_860_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_860_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_travel_860_m RESULT result.

    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_860_m~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_860_m~copytravel.

    METHODS recaltotalprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_860_m~recaltotalprice.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_860_m~rejecttravel RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_travel_860_m RESULT result.

    METHODS validatecustomerid FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_860_m~validatecustomerid.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_travel_860_m~validatedates.

    METHODS totalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_travel_860_m~totalprice.

    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_860_m\_booking.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_860_m.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_860_M IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*      ignore_buffer     =
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )
*      subobject         =
*      toyear            =
          IMPORTING
            number            = DATA(lv_latest_num)
            returncode        = DATA(lv_code)
            returned_quantity = DATA(lv_qty)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(ls_error).

        LOOP AT lt_entities INTO DATA(ls_entities).
          APPEND VALUE #( %cid = ls_entities-%cid
                          %key = ls_entities-%key
          ) TO failed-zi_travel_860_m.

          APPEND VALUE #( %cid = ls_entities-%cid
                          %key = ls_entities-%key
                          %msg = ls_error
          ) TO reported-zi_travel_860_m.

        ENDLOOP.
        EXIT.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).  "Assert means check. Check if lv_qty = lines( lt_entities )

    DATA: lt_travel_860_m TYPE TABLE FOR MAPPED EARLY zi_travel_860_m,
          ls_travel_860_m LIKE LINE OF lt_travel_860_m.

    DATA(lv_curr_num) = lv_latest_num - lv_qty.

    LOOP AT lt_entities INTO ls_entities.

      lv_curr_num = lv_curr_num + 1.

      ls_travel_860_m = VALUE #( %cid = ls_entities-%cid
      TravelId = lv_curr_num
      ).

      APPEND ls_travel_860_m TO mapped-zi_travel_860_m.

    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    DATA: lv_booking_max TYPE /dmo/booking_id.

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m BY \_Booking FROM CORRESPONDING #( entities )
    LINK DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>) GROUP BY <ls_group_entity>-TravelId.
      lv_booking_max = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                 FOR ls_link IN lt_link_data USING KEY entity
                                 WHERE ( source-TravelId = <ls_group_entity>-TravelId )
                                 NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                     THEN ls_link-target-BookingId
                                                                     ELSE lv_max ) ).

      lv_booking_max = REDUCE #( INIT lv_max = lv_booking_max
                                 FOR ls_entity IN entities USING KEY entity
                                 WHERE ( TravelId = <ls_group_entity>-TravelId )
                                 FOR ls_booking IN ls_entity-%target
                                 NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId
                                                                      THEN ls_booking-BookingId
                                                                      ELSE lv_max ) ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>) USING KEY entity WHERE TravelId = <ls_group_entity>-TravelId .

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #( <ls_booking> ) TO mapped-zi_booking_860_m ASSIGNING FIELD-SYMBOL(<ls_new_booking>).
          <ls_new_booking>-BookingId = lv_booking_max.
          IF <ls_booking>-BookingId IS INITIAL.
            lv_booking_max += 10.

          ENDIF.
        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD AcceptTravel.
    MODIFY ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m
    UPDATE FIELDS ( OverallStatus ) WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                                                        OverallStatus = 'A' ) ).
*    REPORTED DATA(lt_reported_travel).

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #(  FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                                    %param = ls_result ) ).

  ENDMETHOD.

  METHOD copyTravel.

    DATA: it_travel      TYPE TABLE FOR CREATE zi_travel_860_m,
          it_booking_cba TYPE TABLE FOR CREATE zi_travel_860_m\_Booking,
          it_booksup_cba TYPE TABLE FOR CREATE zi_booking_860_m\_BookingSupplement.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ''.
    ASSERT <ls_without_cid> IS INITIAL.

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_r)
    FAILED DATA(lt_failed).

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m  BY \_Booking ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
    RESULT DATA(lt_booking_r).

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_booking_860_m  BY \_BookingSupplement ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
    RESULT DATA(lt_booksup_r).

    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).
*      APPEND INITIAL LINE TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*
*      <ls_travel>-%cid = keys[ KEY entity travelid =  <ls_travel_r>-TravelId ]-%cid.
*
*****************Above line is equivalent to below code*******************************************
**      READ TABLE keys INTO DATA(ls_key)
**        WITH KEY travelid = <ls_travel_r>-TravelId.
**
**      <ls_travel>-%cid = ls_key-%cid.
**************************************************************************************************
*
*      <ls_travel>-%data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ).

      APPEND VALUE #( %cid = keys[ KEY entity travelid =  <ls_travel_r>-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId )
                    ) TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date(  ).
      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date(  ) + 30.
      <ls_travel>-OverallStatus = 'O'.

      APPEND VALUE #( %cid_ref = <ls_travel>-%cid ) TO it_booking_cba ASSIGNING FIELD-SYMBOL(<ls_booking>).

      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>) USING KEY entity
      WHERE TravelId = <ls_travel>-TravelId.

        APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId
                        %data = CORRESPONDING #( <ls_booking_r> EXCEPT travelid )
                      ) TO <ls_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_new>).

        <ls_booking_new>-BookingStatus = 'N'.

        APPEND VALUE #( %cid_ref = <ls_booking_new>-%cid ) TO it_booksup_cba ASSIGNING FIELD-SYMBOL(<ls_booksup>).

        LOOP AT lt_booksup_r ASSIGNING FIELD-SYMBOL(<ls_booksup_r>) USING KEY entity
        WHERE TravelId = <ls_travel>-TravelId AND BookingId = <ls_booking_r>-BookingId.

          APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_booksup_r>-BookingSupplementId
                          %data = CORRESPONDING #( <ls_booksup_r> EXCEPT bookingsupplementid )
                        ) TO <ls_booksup>-%target .

        ENDLOOP.
      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m
        CREATE FIELDS ( AgencyId BeginDate BookingFee CreatedAt CreatedBy CurrencyCode CustomerId EndDate Description OverallStatus )
        WITH it_travel
    ENTITY zi_travel_860_m
        CREATE BY \_Booking
        FIELDS ( BookingDate BookingStatus CarrierId ConnectionId CurrencyCode CustomerId FlightDate FlightPrice )
        WITH it_booking_cba
    ENTITY zi_booking_860_m
        CREATE BY \_BookingSupplement
        FIELDS ( BookingSupplementId CurrencyCode Price SupplementId  )
        WITH it_booksup_cba
    MAPPED DATA(it_mapped).

    mapped-zi_travel_860_m = it_mapped-zi_travel_860_m.

  ENDMETHOD.

  METHOD recalTotalPrice.

    TYPES: BEGIN OF ty_price,
             price TYPE /dmo/booking_fee,
             curr  TYPE /dmo/currency_code,
           END OF ty_price.

    DATA: lt_totalprice TYPE TABLE OF ty_price,
          lv_conv_price TYPE ty_price-price.

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m
    FIELDS ( BookingFee CurrencyCode )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DELETE lt_travel WHERE CurrencyCode IS INITIAL.

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m BY \_Booking
    FIELDS ( FlightPrice CurrencyCode )
    WITH CORRESPONDING #( lt_travel )
    RESULT DATA(lt_booking).

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_booking_860_m BY \_BookingSupplement
    FIELDS ( Price CurrencyCode )
    WITH CORRESPONDING #( lt_booking )
    RESULT DATA(lt_booksup).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      lt_totalprice = VALUE #( ( price =  <ls_travel>-BookingFee curr = <ls_travel>-CurrencyCode ) ).

      LOOP AT lt_booking ASSIGNING FIELD-SYMBOL(<ls_booking>) USING KEY entity WHERE TravelId = <ls_travel>-TravelId AND CurrencyCode IS NOT INITIAL.

        APPEND VALUE #( price =  <ls_booking>-FlightPrice curr = <ls_booking>-CurrencyCode ) TO lt_totalprice.

        LOOP AT lt_booksup ASSIGNING FIELD-SYMBOL(<ls_booksup>) USING KEY entity WHERE TravelId = <ls_booking>-TravelId AND BookingId = <ls_booking>-BookingId AND CurrencyCode IS NOT INITIAL.

          APPEND VALUE #( price =  <ls_booking>-FlightPrice curr = <ls_booking>-CurrencyCode ) TO lt_totalprice.

        ENDLOOP.
      ENDLOOP.

      LOOP AT lt_totalprice ASSIGNING FIELD-SYMBOL(<ls_totalprice>).
        IF <ls_totalprice>-curr = <ls_travel>-CurrencyCode.
          lv_conv_price = <ls_totalprice>-price.
        ELSE.
          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
              iv_amount               = <ls_totalprice>-price
              iv_currency_code_source = <ls_totalprice>-curr
              iv_currency_code_target = <ls_travel>-CurrencyCode
              iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
            IMPORTING
              ev_amount               = lv_conv_price
          ).

        ENDIF.
        <ls_travel>-TotalPrice = <ls_travel>-TotalPrice + lv_conv_price.
      ENDLOOP.

    ENDLOOP.
    MODIFY ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m
    UPDATE FIELDS ( TotalPrice )
    WITH CORRESPONDING #( lt_travel ).


  ENDMETHOD.

  METHOD RejectTravel.
    MODIFY ENTITIES OF zi_travel_860_m IN LOCAL MODE
  ENTITY zi_travel_860_m
  UPDATE FIELDS ( OverallStatus ) WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                                                      OverallStatus = 'X' ) ).
*    REPORTED DATA(lt_reported_travel).

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #(  FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                                    %param = ls_result ) ).
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m
    FIELDS ( TravelId OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result
                        ( %tky = ls_result-%tky
                          %features-%action-AcceptTravel = COND #( WHEN ls_result-OverallStatus = 'A'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )
                          %features-%action-RejectTravel = COND #( WHEN ls_result-OverallStatus = 'X'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )
                          %features-%assoc-_Booking = COND #( WHEN ls_result-OverallStatus = 'X'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )
                        )
                     ).
  ENDMETHOD.

  METHOD validateCustomerId.

    READ ENTITY IN LOCAL MODE zi_travel_860_m
    FIELDS ( CustomerId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_validateCustomer).

    DATA: lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    lt_cust = CORRESPONDING #( lt_validateCustomer DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).
    DELETE lt_cust WHERE customer_id IS INITIAL.


    SELECT FROM /dmo/customer FIELDS customer_id FOR ALL ENTRIES IN @lt_cust
    WHERE customer_id = @lt_cust-customer_id INTO TABLE @DATA(lt_cust_db).

    IF sy-subrc IS INITIAL.

    ENDIF.

    LOOP AT lt_validatecustomer ASSIGNING FIELD-SYMBOL(<ls_validatecustomer>).
      IF <ls_validatecustomer>-CustomerId IS INITIAL OR
         NOT line_exists( lt_cust_db[ customer_id = <ls_validatecustomer>-CustomerId ] ).

        APPEND VALUE #( %tky = <ls_validatecustomer>-%tky ) TO failed-zi_travel_860_m.
        APPEND VALUE #( %tky = <ls_validatecustomer>-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                                      textid                = /dmo/cm_flight_messages=>customer_unkown
                                      customer_id           = <ls_validatecustomer>-CustomerId
                                      severity              = if_abap_behv_message=>severity-error )
                        %element-CustomerId = if_abap_behv=>mk-on
                      ) TO reported-zi_travel_860_m.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateDates.

    READ ENTITY IN LOCAL MODE zi_travel_860_m
    FIELDS ( BeginDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_validateDate).

    LOOP AT lt_validateDate ASSIGNING FIELD-SYMBOL(<ls_validateDate>).
      IF <ls_validateDate>-BeginDate > <ls_validateDate>-EndDate.

        APPEND VALUE #( %tky = <ls_validateDate>-%tky ) TO failed-zi_travel_860_m.
        APPEND VALUE #( %tky = <ls_validateDate>-%tky
                          %msg = NEW /dmo/cm_flight_messages(
                                        textid               = /dmo/cm_flight_messages=>begin_date_bef_end_date
                                        begin_date           = <ls_validateDate>-BeginDate
                                        end_date             = <ls_validateDate>-EndDate
                                        travel_id            = <ls_validateDate>-TravelId
                                        severity             = if_abap_behv_message=>severity-error )
                          %element-BeginDate = if_abap_behv=>mk-on
                          %element-EndDate   = if_abap_behv=>mk-on
                        ) TO reported-zi_travel_860_m.
      ELSEIF <ls_validateDate>-BeginDate < cl_abap_context_info=>get_system_date(  ).
        APPEND VALUE #( %tky = <ls_validateDate>-%tky ) TO failed-zi_travel_860_m.
        APPEND VALUE #( %tky = <ls_validateDate>-%tky
                    %msg = NEW /dmo/cm_flight_messages(
                                  textid               = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
                                  severity             = if_abap_behv_message=>severity-error )
                    %element-BeginDate = if_abap_behv=>mk-on
                    %element-EndDate   = if_abap_behv=>mk-on
                  ) TO reported-zi_travel_860_m.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD totalPrice.

    MODIFY ENTITIES OF zi_travel_860_m IN LOCAL MODE
    ENTITY zi_travel_860_m
    EXECUTE recalTotalPrice
    FROM CORRESPONDING #( keys ).

  ENDMETHOD.

ENDCLASS.

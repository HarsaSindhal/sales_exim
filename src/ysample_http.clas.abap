CLASS ysample_http DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

   INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YSAMPLE_HTTP IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).

    DATA(invno) = VALUE #( req[ name = 'invno' ]-value OPTIONAL ) .


try.
     DATA(pdf2) = YSAMPLE_PRINT=>read_posts( invno = invno ) .
  catch cx_static_check.
    "handle exception
endtry.

response->set_text( pdf2   ) .



  ENDMETHOD.
ENDCLASS.

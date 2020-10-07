Planned content:
* Technical setup
    * Setup HANA Cloud Trial
    * Create personal user (not DBADMIN)
    * Access DB Explorer
    * Download data for exercises
    * Upload data to your trial instance
    * Execute test script to see that spatial and graph is working
* Demo scenario
    * data source
    * how data has been prepared (e.g. osmnx)
    * goals (detailed; high-level also on intro site)
* For more background: Devtoberfest on Youtube

# Level 1 Heading

In this exercise, you will...

## Level 2 Heading

After completing these steps you will have....

1.	Click here.
<br>![](/exercises/ex0/images/00_00_0010.png)

2.	Insert this code.
```
 DATA(lt_params) = request->get_form_fields(  ).
 READ TABLE lt_params REFERENCE INTO DATA(lr_params) WITH KEY name = 'cmd'.
  IF sy-subrc <> 0.
    response->set_status( i_code = 400
                     i_reason = 'Bad request').
    RETURN.
  ENDIF.
```

## Summary

Now that you have ... 
Continue to - [Exercise 1 - Exercise 1 Description](../ex1/README.md)

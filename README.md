## Eric's Time Logging Application [![Build Status](https://travis-ci.com/ericdrosado/Time-Logging-App.svg?token=q2QZyZnFyjXpruKTHwxy&branch=master)](https://travis-ci.com/ericdrosado/Time-Logging-App)


### Setup
+ Clone this repository
+ In the root directory: install all of the dependencies using ```bundle install```

### To run:
+ In the root directory:
```
ruby run_logger.rb
```

### Login Information
+ Employee Login with admin permissions: "Eric Rosado"
+ Employee Login without admin permissions: "John Doe"

### To run tests:
+ In the root directory:
```
bundle exec rspec
```

### App Requirements

#### Time Logging Application

Create a command line that employees can use to log their time throughout the week.

#### Entering Time

Employees should be able to start the program by entering their user name as a command line argument.

Once they start the program, they can log their time for a date that they specify.

When logging time, they need to input the following:

Date
Hours worked
Timecode

The program should support three timecodes - Billable Work, Non-billable work, and PTO.

If the user selects "Billable Work", it should prompt them to select their client from a preexisting list.

Employees cannot log time for dates in the future.

#### Reporting on their own time

Employees can request to run a report on the current month of timelogged.

This report should calculate the number of hours worked per project, the number of hours worked for a specific client, and then a detailed report of all time logged in the month. The details should be sorted by date.

#### Persisting Data

Save and load time logging data to a flat file. The data should load from the flat file when starting the program.

#### Admin functions

If the employee is stored as an admin, when they start the program they will have the ability to perform additional actions.

#### Add Employees

Admins can update the employee list by adding new employees. Once an employee is added, that person can log in and perform employee functions.

You should be able to specify if an employee is an admin or not.

#### Add Clients

Admins can update the client list by adding new clients, which are then selectable by employees.

#### All employees report

See a summary report of all employees for the past month, with totals for each code.

Include totals by client as well.

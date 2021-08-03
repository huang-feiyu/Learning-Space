#!/usr/bin/python3
# Encoding: UTF-8
"""
ps1a.py is the solution of pset1 problem-1, google style code.

Author:
    [Huang](https://huang-feiyu.github.io)

Date:
    2021.8.3 15:23
"""

# constants
portion_down_payment = 0.25
r = 0.04
number_month = 12
# user variables
annual_salary = float(input("Enter your annual salary: "))
portion_saved = float(input("Enter the percent of your salary to save, as a "
                            "decimal: "))
total_cost = float(input("Enter the cost of your dream home: "))
# my variables
current_savings = 0.0
monthly_salary = annual_salary / number_month
n = 1  # as a counter

while (monthly_salary * portion_saved + current_savings * (1 + r / 12) <
       total_cost * portion_down_payment):
    current_savings += monthly_salary * portion_saved +\
                       current_savings * (r / 12)
    n += 1
print("Number of months:", n)

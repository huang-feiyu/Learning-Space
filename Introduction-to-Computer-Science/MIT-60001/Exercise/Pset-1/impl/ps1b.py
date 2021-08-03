#!/usr/bin/python3
# Encoding: UTF-8
"""
ps1b.py is the solution of pset1 problem-2, google style code.

Author:
    [Huang](https://huang-feiyu.github.io)

Date:
    2021.8.3 15:53
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
semi_annual_raise = float(input("Enter the semi-annual raise, as a decimal: "))
# my variables
current_savings = 0.0
monthly_salary = annual_salary / number_month
n = 1  # as a counter

while (monthly_salary * portion_saved + current_savings * (1 + r / number_month)
       < total_cost * portion_down_payment):
    current_savings += monthly_salary * portion_saved + \
                       current_savings * (r / number_month)
    if n % 6 == 0:
        annual_salary *= (1 + semi_annual_raise)
        monthly_salary = annual_salary / number_month
    n += 1
print("Number of months:", n)

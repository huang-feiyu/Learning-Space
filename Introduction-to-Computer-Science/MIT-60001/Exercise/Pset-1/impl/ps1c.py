#!/usr/bin/python3
# Encoding: UTF-8
"""
ps1c.py is the solution of pset1 problem-3, google style code.

Author:
    [Huang](https://huang-feiyu.github.io)

Date:
    2021.8.3 15:23
"""

# constants
semi_annual_raise = 0.07
portion_down_payment = 0.25
total_cost = 1000000
r = 0.04
number_month = 12
target_months = 3 * number_month
round_error = 100
# user variables
annual_salary = float(input("Enter your annual salary: "))
# my variables
max_rate = 10000
min_rate = 0
portion_saved = (max_rate + min_rate) / 2
current_savings = 0.0
monthly_salary = annual_salary / number_month
n = 0  # as a counter
steps = 0
while n != 36:
    n = 0
    while total_cost * portion_down_payment - current_savings >= round_error:
        if n % 6 == 0:
            monthly_salary *= 1 + semi_annual_raise
        n += 1
        current_savings *= 1 + r / number_month
        current_savings += monthly_salary * (portion_saved / 100)
    if n < target_months:
        max_rate = portion_saved
    else:
        min_rate = portion_saved
    portion_saved = (max_rate + min_rate) / 2
    steps += 1
    current_savings = 0.0
    monthly_salary = annual_salary / number_month

if portion_saved / 100.0 > 1:
    print("It is not possible to pay the down payment in three years")
else:
    print("Best Saving Rate: ", round(portion_saved / 100.0, 4))
    print("Steps in bisection search: ", steps)

(* Description: solution to UW programming language homework 1
 * Author: huang-feiyu@github
 * Date: 2022-03-14
 **)

(* 1 *)
fun is_older(date_prev : int * int * int, date_next : int * int * int) =
  (#1 date_prev < #1 date_next)
  orelse (#1 date_prev = #1 date_next andalso #2 date_prev < #2 date_next)
  orelse (#1 date_prev = #1 date_next andalso #2 date_prev = #2 date_next andalso #3 date_prev <= #3 date_next)

(* 2 *)
fun number_in_month(dates : (int * int * int) list, month : int) =
  if null dates then 0
  else
    let
      fun number(dates : (int * int * int) list, count : int) =
        if null dates then count
        else if #2 (hd dates) = month then number(tl dates, count + 1)
        else number(tl dates, count)
    in number(dates, 0)
    end

(* 3 *)
fun number_in_months(dates : (int * int * int) list, months : int list) =
  if null months then 0
  else number_in_month(dates, hd months) + number_in_months(dates, tl months)

(* 4 *)
fun dates_in_month(dates : (int * int * int) list, month : int) =
  if null dates then []
  else
    let val tl_dates_in_month = dates_in_month(tl dates, month)
    in
      if #2 (hd dates) = month
      then (hd dates) :: tl_dates_in_month
      else tl_dates_in_month
    end

(* 5 *)
fun dates_in_months(dates : (int * int * int) list, months : int list) =
  if null months then []
  else dates_in_month(dates, hd months) @ dates_in_months(dates, tl months)

(* 6 *)
fun get_nth(strings : string list, n : int) =
  if n = 1
  then hd strings
  else get_nth(tl strings, n - 1)

(* 7 *)
fun date_to_string(date : int * int * int) =
  let val names_of_months = ["January", "February", "March", "April",
    "May", "June", "July", "August", "September", "November", "December"]
  in
    get_nth(names_of_months, #2 date) ^ " " ^
    Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
  end

(* 8 *)
fun number_before_reaching_sum(sum : int, ints : int list) =
  if hd ints >= sum then 0
  else 1 + number_before_reaching_sum(sum - (hd ints), tl ints)

(* 9 *)
fun what_month(day : int) =
  let val days_of_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  in number_before_reaching_sum(day, days_of_months) + 1
  end

(* 10 *)
fun month_range(day1 : int, day2 : int) =
  if day1 > day2 then []
  else what_month(day1) :: month_range(day1 + 1, day2)


(* 11 *)
fun oldest(dates : (int * int * int) list) =
  if null dates then NONE
  else
    let
      fun oldest_nonempty(dates : (int * int * int) list) =
        if null (tl dates)
        then hd dates
        else
          let val tl_oldest = oldest_nonempty(tl dates)
          in
            if is_older(hd dates, tl_oldest) then hd dates
            else tl_oldest
          end
    in SOME (oldest_nonempty(dates))
    end

(* 12 *)
fun remove_duplicates(nums : int list)=
  let fun duplicate(x : int, l : int list)=
    if null l
    then false
    else hd l = x orelse duplicate(x, tl l)
  in
    if null nums then []
    else
      let val s = remove_duplicates(tl nums)
      in
        if duplicate(hd nums,s) then s
        else hd nums::s
      end
  end

fun number_in_months_challenge(dates : (int * int * int) list, months : int list) =
  number_in_months(dates, remove_duplicates(months))

fun dates_in_months_challenge(dates : (int * int * int) list, months : int list) =
  dates_in_months(dates, remove_duplicates(months));

(* 13 *)
fun resonable_date(date : int * int * int) =
  let
    val year = #1 date
    val month = #2 date
    val day = #3 date
    val is_leap = (year mod 4 = 0) andalso ((year mod 100 <> 0)
      orelse (year mod 400 = 0))
    val days_of_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    fun get_nth(months : int list, n : int) =
      if n = 1
      then hd months
      else get_nth(tl months, n - 1)
  in
    (year > 0) andalso (month >= 1) andalso (month <= 12) andalso (day > 0)
    andalso (
    if month = 2 andalso is_leap
    then day <= get_nth(days_of_months, month) - 1
    else day <= get_nth(days_of_months, month))
  end

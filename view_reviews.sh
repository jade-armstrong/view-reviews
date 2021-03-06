#!/bin/sh

p_flag=false
n_flag=false
a_flag=false
u_flag=false
g_flag=false

while getopts ':p:n:au:g' flag
do
    case "$flag" in
        p) 
	   PROJECT=$OPTARG
	   p_flag=true
	   ;;
        n) 
	   NUMBER=$OPTARG
	   n_flag=true
	   ;;
	a) 
	   a_flag=true
	   ;;
        u) 
	   USERNAME=$OPTARG
	   u_flag=true
	   ;;
	g) 
	   g_flag=true
	   ;;
    esac
done

if [ "$n_flag" = true ] && [ "$p_flag" = true ] && [ "$a_flag" = false ]
then
  wtc-lms reviews 2>/dev/null | grep "Invited" -A2 | grep "$PROJECT" -A2 -m "$NUMBER"
elif [ "$n_flag" = true ] && [ "$p_flag" = true ] && [ "$a_flag" = true ]
then
  wtc-lms reviews 2>/dev/null | grep "Invited" -A2 | grep "$PROJECT" -A2 -m "$NUMBER" | grep "accept" | sh
elif [ "$p_flag" = true ] && [ "$a_flag" = true ]
then
  wtc-lms reviews 2>/dev/null | grep "Invited" -A2 | grep "$PROJECT" -A2 -m 3 | grep "accept" | sh
elif [ "$p_flag" = true ]
then
  wtc-lms reviews 2>/dev/null | grep "Invited" -A2 | grep "$PROJECT" -A2 -m 3
elif [ "$u_flag" = true ] && [ "$p_flag" = false ] && [ "$n_flag" = false ] && [ "$a_flag" = false ] && [ ! -z "$USERNAME" ]
then
  wtc-lms reviews | grep "Assigned" -A1 | grep "review_details" | sh | grep "$USERNAME" -A3 -B5
elif [ "$u_flag" = false ] && [ "$p_flag" = false ] && [ "$n_flag" = false ] && [ "$a_flag" = false ] && [ ! -z "$USERNAME" ] && [ "$g_flag" = false ] && [ "$#" -gt 0 ]
then
  wtc-lms reviews | grep "Assigned" -A1 | grep "review_details" | sh
elif [ "$u_flag" = false ] && [ "$p_flag" = false ] && [ "$n_flag" = false ] && [ "$a_flag" = false ] && [ "$g_flag" = true ]
then
  wtc-lms reviews | grep "Graded" -c
else
  echo "This script needs to be called with flags:"
  echo "   -p -n -a OR -u OR -g"
  echo "   -p \"projectname\"   Use this flag to specify a project name to see available reviews."
  echo "   -n 1               (OPTIONAL) Use this flag when using the -p flag to specifiy the number of available reviews to see. Default set to 3."
  echo "   -a                 (OPTIONAL) Use this flag with no arguments to ACCEPT the specified or default number of reviews for the specified project."
  echo "   -u \"username\"      Use this flag without the argument to view all assigned reviews. Use with the argument to view all assigned reviews for the specified user."
  echo "   -g                 Use this flag to see the total number of reviews you have completed thus far."
fi

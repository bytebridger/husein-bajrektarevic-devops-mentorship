
# =========
# INTEGERS
# =========

# an integer is a whole number, for example 50
# the data type integer is abbreviated to int

# ================
# FLOATING POINTS
# ===============

# a floating point number is a number
# followed by a decimal point such as 50.5

# ==================================
# USING NUMBER VARIABLES IN STRINGS
# =================================

# When it comes to adding strings together
# to form sentences, we can use + symbol
# we also mentioned previously that we can
# insert variables into a sentence using the { }

my_int = 50
sentence = "The total comes to: "

print(sentence + my_int)

# We will get an ERROR
# TypeError: can only concatenate str (not "int") to str
# TypeErrors are very common. Python is telling
# us that we are trying to use a data type
# that will not work.
# We cannot add a string and a number together.

# We can fix this by converting the int data type
# to a str data type

my_int = 50
sentence = "The total comes to: "

print(sentence + str(my_int)) # conversion

# ==============
# str() method
# =============

# We used the str() method to convert 
# the variable from an integer to a string.

# Other useful methods are: 

str()   # returns a string object
int()   # returns an integer object
float() # returns a floating point object
bool()  # a boolean value of True or False


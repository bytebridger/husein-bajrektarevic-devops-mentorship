
# ========
# STRINGS
# =======

# a string is shortened to str and refers
# to anything inside quotes.
# Quotes can be double or single.

"The quick brown fox jumped over the lazy dog"
'The quick brown fox jumped over the lazy dog'

# to include a direct quote in your sentence
# then use single quotes for the string
# and double quotes for the direct quote.

'The error message was "Incorrect DataType"'

# Strings can be assigned to a variable

first_name = "Monty"
last_name = "Python"

# we can add strings together using variables
# which will concatenate them

print(first_name+last_name)
# OUTPUT: MontyPython


# ===========================
# USING VARIABLES IN STRINGS
# ==========================

# .format() method
# using this method, we can use
# the { } in our string to 
# indicate where the variable should go.
# Then we will use .format(variable_name) 
# after the quotation marks.
# If you have multiple variables, for each
# variable we will use a { }
# In the .format() we should separate each
# variable with a comma, for example:

.format(variable_1, variable_2)

# Example

first_name = "John"
surname = "Doe"
print("My first name is {}. My family name is {}".format(first_name, surname))

# f-strings
# Some people find this format easier to read than .format()

firstname = "Jane"
surname = "Doe"

print(f"My first name is {firstname}. My family name is {surname}")

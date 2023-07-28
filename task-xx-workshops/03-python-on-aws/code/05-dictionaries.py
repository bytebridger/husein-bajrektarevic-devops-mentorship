# A dictionary is a way of storing related information
# in key-value pairs. It uses a key as an identifier
# and a value to store the information.

# Example key could be first_name and the
# value could be Ada

{"first_name":"Ada"}

# dictionary in Python is abbreviated 
# to dict and has the following syntax

{"key":"value"}

# IMPORTANT - Dictionaries are very common
# in AWS and we will see them frequently.

    # used to exchange information between different 
    # services and functions

    # dict are returned by APIs 

    # they are used as tag values.

# ================================================
# Creating, reading, updating and deleting values 
# ===============================================

# CREATE #

# Dictionaries can be created by assigning 
# the key-values you want to store in the dictionary

user = {"first_name":"Ada"}
print(user)
{'first_name': 'Ada'}

# If we are going to be adding the contents of the dictionary
# later, we can declare an empty dictionary - in two ways.
# First way would be assigning { } to a variable, example:

account_details = {}

# or using the dict() constructor

account_details = dict()

# READ # 

# To read the value associated with a key, we need
# to provide the name of the dictionary and
# the value of the key inside square brackets.

user = {"first_name":"Ada"}
print(user["first_name"])
# Output: Ada

# UPDATE #

## Add a key-value

# Dictionaries are mutable, which means that
# they can be changed after you create them.
# We can add, update or delete the key-value
# pairs in a dictionary.

# To add an additinal key-value to a dictionary
# we provide the dictionary name
# the new key in [ ] and a value after a = sign

user["family_name"] = "Byron"
print(user)
{'first_name': 'Ada', 'family_name': 'Byron'}

## Modify a value

# To modify a value in a similar way to adding it.
# We provide the new value after the = sign.

user["family_name"] = "Lovelace"
print(user)
{'first_name': 'Ada', 'family_name': 'Lovelace'}

## Delete a key-value pair

# To remove a key-value pair you use the del statement
# with the name of the dictionary and the
# key you want to delete

del user["family_name"]
print(user)
{'first_name': 'Ada'}

## Summary

# A dictionary, like a variable can contain other data types,
# including other dictionaries and lists.
# We will use dictionaries a lot in AWS as input
# and outputs. 
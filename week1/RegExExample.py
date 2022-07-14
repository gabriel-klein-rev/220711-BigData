import re

# m = re.search(',', "Hello, How are you?,  ,")
# fa = re.findall(',', "Hello, How are you?,  ,")
# print(m.span())

'''
(123) 456-7890
123-456-7890
(123)-456-7890
123 456 7890
123 456-7890

[a-z]
\(?\d{3}\)?[\- ]?\d{3}[\- ]?\d{4}
'''
# print(r'\n')

check_phone = "asdfasd f 123 456 7890 asdfasdfasd (123) 456-7890 asdf (321)-345 2345"
fa = re.findall(r'\(?\d{3}\)?[\- ]?\d{3}[\- ]?\d{4}', check_phone)

name = "asdf, asdf, asdf,asdf,"
check = re.search(',', name)

print(fa)

# print(fa)
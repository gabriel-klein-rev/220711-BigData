'''
OOP
- Inheritence
    - Child classes inherit methods and attributes from parent class
- Polymorphism
    - "Many Forms"
    - Ability of an object to be different classes
    - Method Overriding
        - Changing behavior of a method inherited from a parent class
    - Method Overloading
        - Method polymorphism. Methods behave differently given different arguments.
        - *** NOT FULLY IMPLEMENTED IN PYTHON ***
- Encapsulation
    - Having control over your attributes/data members
    - Achieve encapsulation by making attributes private
        - *** CAN"T MAKE ATTRIBUTES PRIVATE IN PYTHON ***
            - "Emulate" by prefixing attributes with _
        - Access attributes with control using setter/getter methods

'''

class Animal:
    def __init__(self, name, age, color=""):
        self._name = str(name)
        self._age = int(age)
        self._color = str(color)

    def setName(self, name):
        self._name = str(name)

    def getName(self):
        return self._name

    # def getPhoneNumber(self):
    #     return "xxx-xxx-" + _phoneNumber[-4:]

    def sleep(self):
        print("***zzz***")

    def getOlder(self, years=1):
        self._age += years
    
    # def getOlder(self):
    #     self.age += 1

    def move(self):
        print("*", self._name, "has moved. *")

    def __str__(self):
        return "Name: " + self._name + ", Age: " + str(self._age) + ", Color: " + self._color

class Dog(Animal):
    def sleep(self):
        print("***snore***")

    def move(self):
        print("*", self._name, "ran. *")

class Cat(Animal):
    def sleep(self):
        print("***purr***")

    def move(self):
        print("*", self._name, "walked. *")



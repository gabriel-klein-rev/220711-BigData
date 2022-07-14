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
- Abstraction
    - Handling complexity byu hiding unnecessary information from the user
    - Achieved by using abstract classes
        - Class that has one or more abstract methods
            - Abstract method => unimplemented method
    - abc (Abstract Base Class) module used to create abstract classes

'''

from abc import ABC, abstractmethod

class Animal(ABC):
    def __init__(self, name, age, color=""):
        self._name = str(name)
        self._age = int(age)
        self._color = str(color)

    def setName(self, name):
        self._name = str(name)

    def getName(self):
        return self._name

    @abstractmethod
    def sleep(self):
        pass

    def getOlder(self, years=1):
        self._age += years

    @abstractmethod
    def move(self):
        pass

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

class Horse(Animal):
    def sleep(self):
        print("***sleep***")
    
    def move(self):
        print("*", self.name, "galloped *")

    def feed(self):
        print("** Fed", self.name, "a carrot. **")
    




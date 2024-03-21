// Test class: CalculatorTest

@isTest
private class CalculatorTest {
    
    @isTest
    static void testAdd() {
        // Arrange
        Integer num1 = 5;
        Integer num2 = 3;
        
        // Act
        Integer result = Calculator.add(num1, num2);
        
        // Assert
        System.assertEquals(8, result, 'Incorrect addition result');
    }
    
    @isTest
    static void testSubtract() {
        // Arrange
        Integer num1 = 10;
        Integer num2 = 4;
        
        // Act
        Integer result = Calculator.subtract(num1, num2);
        
        // Assert
        System.assertEquals(6, result, 'Incorrect subtraction result');
    }
    
}
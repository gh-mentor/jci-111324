#include <cppunit/TestFixture.h>
#include <cppunit/extensions/HelperMacros.h>
#include "Employees.h"

class EmployeesTest : public CppUnit::TestFixture {
    CPPUNIT_TEST_SUITE(EmployeesTest);
    CPPUNIT_TEST(testHighEarners);
    CPPUNIT_TEST_SUITE_END();

public:
    void setUp() override {
        // Set up code if needed
    }

    void tearDown() override {
        // Clean up code if needed
    }

    void testHighEarners() {
        Employees employees;
        // Add employees with different salaries
        employees.addEmployee("John Doe", 50000);
        employees.addEmployee("Jane Smith", 120000);
        employees.addEmployee("Alice Johnson", 90000);

        // Define a strategy for high earners (e.g., salary > 100000)
        auto highEarnerStrategy = [](double salary) { return salary > 100000; };

        // Get high earners using the strategy
        auto highEarners = employees.HighEarners(highEarnerStrategy);

        // Check the results
        CPPUNIT_ASSERT_EQUAL(1, static_cast<int>(highEarners.size()));
        CPPUNIT_ASSERT_EQUAL(std::string("Jane Smith"), highEarners[0].getName());
    }
};

CPPUNIT_TEST_SUITE_REGISTRATION(EmployeesTest);
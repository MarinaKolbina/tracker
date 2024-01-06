# Specification of a mobile application for tracking habits

# Links

[Figma Design](https://www.figma.com/file/owAO4CAPTJdpM1BZU5JHv7/Tracker-(YP)?t=SZDLmkWeOPX4y6mp-0)

# Purpose and goals of the application

The application helps users form healthy habits and monitor their implementation.

Application goals:

- Control of habits by day of the week;
- View progress by habits;

# Brief description of the application

- The application consists of tracker cards that the user creates. He can specify the name, category and set the schedule. You can also choose an emoji and color to differentiate the cards from each other.
- Cards are sorted by category. The user can search for them using search and filter.
- Using the calendar, the user can see what habits he has planned for a specific day.
- The application has statistics that reflect the user's successful performance, progress and average values.

# Functional requirements

## Onboarding

When logging into the app for the first time, the user is taken to an onboarding screen.

**The onboarding screen contains:**

1. Screensaver;
2. Title and secondary text;
3. Page controls;
4. The “This is technology” button.

**Algorithms and available actions:**

1. By swiping right and left, the user can switch between pages. When switching pages, page controls change state;
2. When you click on the “This is technology” button, the user goes to the main screen.

## Creating a habit card

From the home screen, the user can create a tracker for a habit or irregular event. A habit is an event that repeats with a certain frequency. An irregular event is not tied to specific days.

**The habit tracker creation screen contains:**

1. Screen title;
2. Field for entering the name of the tracker;
3. Category section;
4. Schedule settings section;
5. Emoji section;
6. Section with the choice of tracker color;
7. “Cancel” button;
8. “Create” button.

**The screen for creating a tracker for an irregular event contains:**

1. Screen title;
2. Field for entering the name of the tracker;
3. Category section;
4. Emoji section;
5. Section with the choice of tracker color;
6. “Cancel” button;
7. “Create” button.

**Algorithms and available actions:**

1. The user can create a tracker for a habit or irregular event. The algorithm for creating trackers is similar, but the event does not have a schedule section.
2. The user can enter the name of the tracker;
     1. After entering one character, a cross icon appears. By clicking on the icon, the user can delete the entered text;
     2. The maximum number of characters is 38;
     3. If the user has exceeded the allowed quantity, an error text appears;
3. When you click on the “Category” section, the category selection screen opens;
     1. If the user has not previously added categories, then there is a stub;
     2. The last selected category is marked with a blue checkmark;
     3. By clicking on “Add category” the user can add a new one.
         1. A screen will open with a field for entering a name. The "Done" button is inactive;
         2. If at least 1 character is entered, the “Done” button becomes active;
         3. Clicking the “Done” button closes the category creation screen and returns the user to the category selection screen. The created category appears in the list of categories. There is no automatic selection or ticking.
         4. When you click on a category, it is marked with a blue checkmark and the user returns to the habit creation screen. The selected category is displayed on the habit creation screen as secondary text under the “Category” heading;
4. In habit creation mode, there is a “Schedule” section. When you click on a section, a screen opens with a choice of days of the week. The user can toggle the switch to select the day the habit will be repeated;
     1. Clicking “Done” returns the user to the habit creation screen. The selected days are displayed on the habit creation screen as secondary text under the “Schedule” heading;
         1. If the user has selected all days, the text “Every day” is displayed;
5. The user can select an emoji. A background appears under the selected emoji;
6. The user can select the color of the tracker. A stroke appears on the selected color;
7. By clicking the “Cancel” button, the user can stop creating the habit;
8. The “Create” button is inactive until all sections are completed. When you press the button, the main screen opens. The created habit is displayed in the corresponding category;

## View the main screen

On the main screen, the user can view all created trackers for the selected date, edit them and view statistics.

**Home screen contains:**

1. “+” button to add a habit;
2. Heading “Trackers”;
3. Current date;
4. Field for searching for trackers;
5. Tracker cards by category. Cards contain:
     1. Emoji;
     2. Tracker name;
     3. Number of tracked days;
     4. Button to mark a completed habit;
6. “Filter” button;
7. Tab bar.

**Algorithms and available actions:**

1. When you click on “+”, a curtain pops up with the ability to create a habit or an irregular event;
2. When you click on a date, the calendar opens. The user can switch between months. When you click on a number, the app shows trackers corresponding to the date;
3. The user can search for trackers by name in the search window;
     1. If nothing is found, then the user sees a stub;
4. When you click on “Filters”, a curtain pops up with a list of filters;
     1. There is no filter button if there are no trackers for the selected day;
     2. When selecting “All trackers”, the user sees all trackers for the selected day;
     3. When selecting “Trackers for today,” the current date is set and the user sees all trackers for that day;
     4. When selecting “Completed”, the user sees the habits that were completed by the user on the selected day;
     5. When selecting “Unfinished”, the user sees the uncompleted trackers on the selected day;
     6. The current filter is marked with a blue tick;
     7. When you click on the filter, the curtain disappears and the corresponding trackers are displayed on the screen;
         1. If nothing is found, then the user sees a stub;
5. When scrolling down and up, the user can view the feed;
     1. If the card image did not have time to load, the system loader is displayed;
6. When you click on a card, the background underneath it is blurred and a modal window pops up;
     1. The user can pin the card. The card will appear in the “Pinned” category at the top of the list;
         1. When clicked again, the user can unpin the card;
         2. If there are no pinned cards, then the “Pinned” category is missing;
     2. The user can edit the card. A modal window pops up with functionality similar to creating a card;
     3. When you click “Delete,” an action sheet pops up.
         1. The user can confirm the deletion of the card. All data about her must be deleted;
         2. The user can cancel the action and return to the main screen;
7. Using the tab bar, the user can switch between the “Trackers” and “Statistics” sections.

## Editing and deleting a category

When creating a tracker, the user can edit categories in the list or delete unnecessary ones.

**Algorithms and available actions:**

1. When you long press a category from the list, the background underneath it is blurred and a modal window appears;
     1. When you click on “Edit”, a modal window pops up. The user can edit the category name. When clicking the “Done” button, the user returns to the list of categories;
     2. When you click “Delete” an action sheet pops up.
         1. The user can confirm the deletion of the category. All data about her must be deleted;
         2. The user can cancel the action;
         3. After confirmation or cancellation, the user returns to the list of categories;

## View statistics

In the statistics tab, the user can see successful indicators, his progress and average values.

**Statistics screen contains:**

1. Heading “Statistics”;
2. List with statistical indicators. Each indicator contains:
     1. Title-number;
     2. Secondary text with the name of the indicator;
3. Tab bar

**Algorithms and available actions:**

1. If there is no data for any indicator, then the user sees a stub;
2. If there is data for at least one indicator, then the statistics are displayed. Indicators without data are displayed with a value of zero;
3. The user can view statistics on the following indicators:
     1. “Best period” counts the maximum number of days without a break for all trackers;
     2. “Ideal days” counts the days when all planned habits were completed;
     3. “Trackers completed” counts the total number of completed habits for the entire time;
     4. “Average” counts the average number of habits completed in 1 day.

## Dark theme

The app has a dark theme that changes depending on the device's system settings.

# Non-functional requirements

1. The application must support iPhone X and higher and adapted for iPhone SE, the minimum supported operating system version is iOS 13.4;
2. The application uses the standard iOS font – SF Pro.
3. Core Data is used to store habit data.

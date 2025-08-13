
-- 1. Scalar subquery: Show books published after the average year
SELECT Title, PublishedYear
FROM Books
WHERE PublishedYear > (SELECT AVG(PublishedYear) FROM Books);

-- 2. IN subquery: Members who borrowed books in the 'Fiction' genre
SELECT Name
FROM Members
WHERE MemberID IN (
    SELECT MemberID
    FROM Borrowing
    WHERE BookID IN (
        SELECT BookID FROM Books WHERE Genre = 'Fiction'
    )
);

-- 3. EXISTS subquery: Authors who have written books
SELECT Name
FROM Authors a
WHERE EXISTS (
    SELECT 1 FROM Books b WHERE b.AuthorID = a.AuthorID
);

-- 4. Correlated subquery: Books that are the latest by their author
SELECT Title, AuthorID, PublishedYear
FROM Books b1
WHERE PublishedYear = (
    SELECT MAX(PublishedYear)
    FROM Books b2
    WHERE b1.AuthorID = b2.AuthorID
);

-- 5. FROM subquery (Derived Table): Count of books by genre
SELECT Genre, Total
FROM (
    SELECT Genre, COUNT(*) AS Total
    FROM Books
    GROUP BY Genre
) AS GenreCount;

-- 6. Nested IN subquery: Members who borrowed a book written by 'J.K. Rowling'
SELECT Name
FROM Members
WHERE MemberID IN (
    SELECT MemberID
    FROM Borrowing
    WHERE BookID IN (
        SELECT BookID
        FROM Books
        WHERE AuthorID = (
            SELECT AuthorID FROM Authors WHERE Name = 'J.K. Rowling'
        )
    )
);

-- 7. Subquery with comparison: Books more popular than average borrow count
SELECT Title
FROM Books
WHERE BookID IN (
    SELECT BookID
    FROM Borrowing
    GROUP BY BookID
    HAVING COUNT(*) > (
        SELECT AVG(BorrowCount)
        FROM (
            SELECT COUNT(*) AS BorrowCount
            FROM Borrowing
            GROUP BY BookID
        ) AS Sub
    )
);

-- Each table includes:
-- 1. Functional Dependencies (FDs)
-- 2. Candidate Keys
-- 3. 3NF Justification
-- 4. Design Rationale
DROP TABLE IF EXISTS NER_Tag CASCADE;
DROP TABLE IF EXISTS Step CASCADE;
DROP TABLE IF EXISTS Recipe_Ingredient CASCADE;
DROP TABLE IF EXISTS Ingredient CASCADE;
DROP TABLE IF EXISTS Recipe CASCADE;

-- TABLE: Recipe
-- Purpose:
-- Stores core information about each recipe.
-- Primary Key:
-- recipe_id
-- Candidate Keys:
-- recipe_id, title (title is UNIQUE)
-- Functional Dependencies:
-- recipe_id → title, directions, link, source
-- title → recipe_id, directions, link, source
-- 3NF Justification:
-- - All non-key attributes depend only on the primary key.
-- - No partial dependency (single attribute PK).
-- - No transitive dependencies exist.
-- Design Rationale:
-- Separating recipe data ensures that recipe details
-- are stored once and not repeated across ingredients or steps.
CREATE TABLE Recipe (
    recipe_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL UNIQUE,
    directions TEXT NOT NULL,
    link VARCHAR(500),
    source VARCHAR(255)
);

 
-- TABLE: Ingredient
-- Purpose:
-- Stores unique ingredients used across recipes.
-- Primary Key:
-- ingredient_id
-- Candidate Keys:
-- ingredient_id, name (name is UNIQUE)
-- Functional Dependencies:
-- ingredient_id → name, category
-- name → ingredient_id, category
-- 3NF Justification:
-- - No partial dependencies.
-- - No transitive dependencies.
-- - All attributes depend only on the key.
-- Design Rationale:
-- Ingredients are stored separately to avoid duplication
-- when the same ingredient is used in multiple recipes.
 CREATE TABLE Ingredient (
    ingredient_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50)
);


 
-- TABLE: Recipe_Ingredient (Associative Entity)
-- Purpose:
-- Resolves the many-to-many relationship between Recipe and Ingredient.
-- Primary Key:
-- (recipe_id, ingredient_id)
-- Functional Dependencies:
-- (recipe_id, ingredient_id) → quantity, unit
-- 3NF Justification:
-- - Composite key fully determines all non-key attributes.
-- - No partial dependency (attributes depend on entire key).
-- - No transitive dependencies.
-- Design Rationale:
-- Allows each recipe to have multiple ingredients and each
-- ingredient to belong to multiple recipes, while storing
-- specific quantities per recipe.
 CREATE TABLE Recipe_Ingredient (
    recipe_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    quantity VARCHAR(50),
    unit VARCHAR(50),
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id) ON DELETE CASCADE
);

 
-- TABLE: Step
-- Purpose:
-- Stores ordered steps for preparing each recipe.
-- Primary Key:
-- step_id
-- Candidate Key (implicit):
-- (recipe_id, step_number)
-- Functional Dependencies:
-- step_id → recipe_id, step_number, description
-- (recipe_id, step_number) → description
-- 3NF Justification:
-- - All attributes depend on the primary key.
-- - No partial dependencies.
-- - No transitive dependencies.
-- Design Rationale:
-- Separating steps allows multiple instructions per recipe
-- and preserves their sequence using step_number.
 
CREATE TABLE Step (
    step_id SERIAL PRIMARY KEY,
    recipe_id INT NOT NULL,
    step_number INT NOT NULL CHECK (step_number > 0),
    description TEXT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id) ON DELETE CASCADE
);


 
-- TABLE: NER_Tag
-- Purpose:
-- Stores tags (e.g., extracted via NLP) associated with recipes.
-- Primary Key:
-- ner_id
-- Functional Dependencies:
-- ner_id → recipe_id, tag
-- 3NF Justification:
-- - All attributes depend only on the primary key.
-- - No partial or transitive dependencies.
-- Design Rationale:
-- Keeps tagging flexible and avoids repeating tag data
-- inside the Recipe table. 
CREATE TABLE NER_Tag (
    ner_id SERIAL PRIMARY KEY,
    recipe_id INT NOT NULL,
    tag VARCHAR(50) NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id) ON DELETE CASCADE
);


SELECT * FROM Recipe;
SELECT * FROM Ingredient;
SELECT * FROM Recipe_Ingredient;
SELECT * FROM Step;
SELECT * FROM NER_Tag;
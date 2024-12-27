CREATE TABLE `college_website`.`users` (
                                           `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                           `name` VARCHAR(32) NOT NULL,
                                           `type` INT NOT NULL,
                                           PRIMARY KEY (`id`),
                                           UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);

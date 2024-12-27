CREATE TABLE `college_website`.`questions` (
                                               `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                               `title` VARCHAR(1024) NOT NULL,
                                               `author` INT NOT NULL,
                                               PRIMARY KEY (`id`),
                                               UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
                                               CONSTRAINT `fk_author`
                                                   FOREIGN KEY (`id`)
                                                       REFERENCES `college_website`.`users` (`id`)
                                                       ON DELETE NO ACTION
                                                       ON UPDATE NO ACTION);

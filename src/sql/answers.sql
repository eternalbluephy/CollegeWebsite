CREATE TABLE `college_website`.`answers` (
                                             `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                             `author` INT UNSIGNED NOT NULL,
                                             `content` VARCHAR(1024) NOT NULL,
                                             PRIMARY KEY (`id`),
                                             UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
                                             CONSTRAINT `fk_answers_author`
                                                 FOREIGN KEY (`id`)
                                                     REFERENCES `college_website`.`users` (`id`)
                                                     ON DELETE NO ACTION
                                                     ON UPDATE NO ACTION);
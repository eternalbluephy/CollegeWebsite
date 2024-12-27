CREATE TABLE `college_website`.`articles` (
                                          `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                                          `title` VARCHAR(64) NOT NULL,
                                          `time` DATETIME NOT NULL,
                                          `views` INT UNSIGNED NOT NULL,
                                          `cover` VARCHAR(128) NOT NULL,
                                          `content_id` INT UNSIGNED NOT NULL,
                                          PRIMARY KEY (`id`),
                                          UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
                                          INDEX `fk_content_id_idx` (`content_id` ASC) VISIBLE,
                                          CONSTRAINT `fk_content_id`
                                              FOREIGN KEY (`content_id`)
                                                  REFERENCES `college_website`.`content` (`id`)
                                                  ON DELETE NO ACTION
                                                  ON UPDATE NO ACTION);
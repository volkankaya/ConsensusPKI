-- --------------------------------------------------------
-- Host:                         consensuspkidbhost
-- Server version:               10.3.10-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping data for table consensuspki.ca_certificateblockchain: ~10 rows (approximately)
/*!40000 ALTER TABLE `ca_certificateblockchain` DISABLE KEYS */;
INSERT INTO `ca_certificateblockchain` (`Year`, `Height`, `PreviousBlockHeader`, `BlockHeader`, `CACertificate`, `MerkleRoot`, `Nonce`, `BlockTimestamp`) VALUES
	(2018, 2, '000232cb9e9f5d2953154977891c3cb5c48be585f8c4f435b5b8c053225c38ab', '0004300585b7101cf0bbea72f0f57a39848ae6a4e3154abae1ef4320c2d91837', '{\r\n"V":"4",\r\n"H":"SHA256",\r\n"VT":"2018-12-23T13:28:06.419Z",\r\n"CN":"node2.consensuspki.org",\r\n"SP": 5502,\r\n"PublicKey":"-----BEGIN PUBLIC KEY-----\\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAi7C1rABVtSgYDzWyNySr\\nGlCNCYNUbob+dTD69AW0z0D6YE7hQ1y40Q2KyUwXrCTOBD95/76MJOd9uerrgqiE\\n+vcq282mq1mkjfiZStR8Y4GB8YAU7WWMno/lxOI8PVvuxw2NsQ2UeA/Xhmuna64b\\naMr1t3i9g7GEuOCLVL24Jsdjec4CBJ6ADtK+/upjS8zG6cyC1sYyWkXTvUZDvkTk\\nHr8+SEnP8bOLmgMtN6GATuPNlWlJBP5XeahpZNDUZkVd161MvjSLJl1d9v14+q/H\\nXkDIY0QJeCun0sQpXF99/BWwUGaezNFECQ/f5T5JA9ANj4vqdLxRUECeCXCkHcI7\\n9QIDAQAB\\n-----END PUBLIC KEY-----"\r\n}', '929a09886475aa8b7bc7452845a0aac579785b3af32c7c581ca9b867855ff89b', 4300, '2018-12-09 21:29:48'),
	(2018, 3, '0004300585b7101cf0bbea72f0f57a39848ae6a4e3154abae1ef4320c2d91837', '000ef102414802eb60a413c1978784eef87a8bf7844b71b2fae4a7e39ef52539', '{\r\n"V":"4",\r\n"H":"SHA256",\r\n"VT":"2018-12-24T13:28:06.419Z",\r\n"CN":"node3.consensuspki.org",\r\n"SP": 5503,\r\n"PublicKey":"-----BEGIN PUBLIC KEY-----\\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvH2e9cjQ9k0jGwpDP0XD\\nRJcvF47MeuSuRzgVMl3ls8kMJbATqR3WdY7FxXV6BRONgZRRXHKrHeb3oc+Gs9lm\\n0c3sYQux03v7OCJWU7luKc8jO/NreDTSDJN9IiqRk3TrZY83mW3U4FySNauL1WFF\\nts3Hv7f7f79SzxPtY8uZ5nnN4T1zb9BSXmXuj5l52meCUS7cQpYd3pruNoxIT9u7\\nH6HrebeRTRnUKlU4fECpQyyxFxgT5O4gb5fMfqDL5OTLJ+RD0Zd8LT2wFvMorwa5\\nccGiXOtqADJwb3E8LC1cb5odX60fKc5BZ79nNVTwtAeGNsJ3TUr1+QzJ+ZduPG6s\\nbwIDAQAB\\n-----END PUBLIC KEY-----"\r\n}', '8b9cdf2c4ebf4d861549e866dc3cc680b645d4fde0718b3897cbb0c903107be7', 5272, '2018-12-09 21:30:07'),
	(2018, 4, '000ef102414802eb60a413c1978784eef87a8bf7844b71b2fae4a7e39ef52539', '0000b0741dcb67abb8786592c265c3176c46cce9f7cf24506c20bdcdc73484c9', '{\r\n"V":"4",\r\n"H":"SHA256",\r\n"VT":"2018-12-25T13:28:06.419Z",\r\n"CN":"node4.consensuspki.org",\r\n"SP": 5504,\r\n"PublicKey":"-----BEGIN PUBLIC KEY-----\\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArT0W5w8g+fs6lPnnyVm4\\nIP/wjtirkpgp6570dYRUjnibO794VTaz5A6ONjI+yePpEH28PT4VmdEaJhKf9oxX\\n85fC0/0aZ38ZBUVCijyvLP3hlqH5a33Q1c9XvcGjVrAuGWT1xa7LyXXS76nvcnKG\\nhhkVaU3logo2gDqy+tTYOWD5cHpVoRcVyeRyXJiYpwhQeTJQkHRKlqyASzuOfCaX\\nhE/v7BrO5manaX2R58OmKAFDCDxcSitVL1H0/1W7nnZcRhvmhq6PCkJ3+guovDgD\\n5xJVvjn7Ro2ywQtxkx8FiluT8XAoL9lwoNCIFi6AL2JNOjXDsM5CoEO5u+OUCyZf\\nmQIDAQAB\\n-----END PUBLIC KEY-----"\r\n}', 'cfbc050163cf3434631d168d781293c9c1a500810b3f2a14a2afacd2dd00c1fb', 612, '2018-12-09 21:30:14'),
	(2019, 2, '0005ee047031101fdf1464d16d7fce935fe28e776a0aec062b1bc87d223c0ed2', '0003f0ae8e913c122d6ab7bb77ede541ca25bae1bb4028fa0fda4db856093bf6', '{\r\n"V":"4",\r\n"H":"SHA256",\r\n"VT":"2019-11-28T13:28:06.419Z",\r\n"CN":"node8.consensuspki.org",\r\n"SP": 5508,\r\n"PublicKey":"-----BEGIN PUBLIC KEY-----\\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx+uA5BoYnv0HUlH162vt\\n+9UDVqRJ5zAYyTJwVOnmEuAukRjGdTBW/cC7MbPhjqMVdZ9rhgGW9/Z4Cu68eMmN\\n+VwjjSKv8cKxX7MJ3M0IsWsaNyvj8vWmPNLCVs2Ftn6nyJ2T+BeO0m0xqdOJxrVE\\n3gOKZXXpk3xfHnaMYvySrTap7MBUCsuhz3Uoh3Pw1+o8b/+Kezmye+rlHyq/DQHC\\ni91gJl0WWFYfbulImtR3tzRI84ZHT22jxWWgktPVkAvJR7vclkNcqBz0bI8uqhhU\\npaAyAVufE8pH7N5K559vkbKh/933sf28YjB4tjc9m6gbv5UURhkq10NxJ9jzoFVx\\nfQIDAQAB\\n-----END PUBLIC KEY-----"\r\n}', '701e634bf94845bbb799409f12d79fe4198894fae0a11fde749933c1199a8420', 4941, '2018-12-09 21:32:23'),
	(2018, 5, '0000b0741dcb67abb8786592c265c3176c46cce9f7cf24506c20bdcdc73484c9', '000532b4d4de8c60a2f376fff373c48c8a5831a0076d09e24f90f8d0d22ac512', '{\r\n"V":"4",\r\n"H":"SHA256",\r\n"VT":"2018-12-27T13:28:06.419Z",\r\n"CN":"node5.consensuspki.org",\r\n"SP": 5505,\r\n"PublicKey":"-----BEGIN PUBLIC KEY-----\\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyyTQOFRAzl3K2Cx+Mph+\\n6Wgw+PTGOw1+zYU11a15BweSoTtfsmrd9fb9xG8Tc9y63jTvhM8A+lxApvab7ULx\\nh3WlBvRxPwfhAI1ltrQD4fEpvDu6TALsu1e6Po/SLUoLABLCpJsGXOSlbKCSXYfa\\n1T5twZQNMH4se8qpqV/lR6FUeAaG6BXginoeWXawL019HPM493cWswUqNzccGJMa\\nanSmWT+49JhDM9Dejlz00BZkjClVueNx4IZZgCHP+AfrZz1k/ChH0oqpaAQW6Z0S\\niowSrMnsKDyhPfCJmkMhGMb09HNCCoV24Jd6CK3NYgAw37dN57yE6ZSgdEiXTd1l\\n8wIDAQAB\\n-----END PUBLIC KEY-----"\r\n}', '336404bddb14968a63933bfaead5192788548b9b74d0737d987f01ce0a14e3d9', 348, '2018-12-09 21:30:22'),
	(2018, 1, '7cd760b107b8fce7278f6e37b5f0afda8851d39cbe3dcf87375fc2ebb9af16e4', '000232cb9e9f5d2953154977891c3cb5c48be585f8c4f435b5b8c053225c38ab', '{\r\n"V":"4",\r\n"H":"SHA256",\r\n"VT":"2018-12-21T13:28:06.419Z",\r\n"CN":"node1.consensuspki.org",\r\n"SP": 5501,\r\n"PublicKey":"-----BEGIN PUBLIC KEY-----\\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0oOMBpLUIwFuHtSJLyIv\\niRT1L6ISg9Yp2wqAVpdglVpiGsRsKUd8RDHryiif/3cGb19c6ht0q1HfkgLNGXJR\\n6f2oPL8D4Ez+rwGQpS85XF7qMzWeD+pF++l7TJxewUVGstWLi3VlkU7IEH7sll8i\\nXTDNVoOJrwn5dc4j0cu+f+i7i8OJKpo2KiMgPuGoWVnQ/J45XqtlVLA65RRGYgzy\\n2j9kfxVD3Y0n6dJiI1i2L5LC/u5Vt175nYLSlaQzTCNBLlwCoGP0Fusf6UWJUm7g\\npsiysiZJ8iDJGgj+aeFHC4orewy6geTiVGxWzoxhQiJ3m1UJXiUSTpzSZ0pHs+FW\\nQwIDAQAB\\n-----END PUBLIC KEY-----"\r\n}', '5e00a26adb897f0599094dd2b08b3a1bf0592867dd4c7c93ab592059be9f6469', 532, '2018-12-09 21:29:29'),
	(2019, 3, '0003f0ae8e913c122d6ab7bb77ede541ca25bae1bb4028fa0fda4db856093bf6', '000895b84d3e78a8c80de62805a16271f2eac19caad28d7959c77bd4c8d721a1', '{\r\n"V":"4",\r\n"H":"SHA256",\r\n"VT":"2019-12-21T13:28:06.419Z",\r\n"CN":"node9.consensuspki.org",\r\n"SP": 5509,\r\n"PublicKey":"-----BEGIN PUBLIC KEY-----\\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAq8eAjENekUwKYCkeJx4F\\nwg/NGdeTRg3PUHGLq6pk6yY/knQq4CUfimy7OctxmJfcxP+W6Dgo4LZc9Yrrfy+Q\\nMLvTvXNCIFOO92W/lHVpzLAitA5hZm1Wo/wnpQAzYpVye9rgHnn4iLHL5AWKdvy5\\nHBILynvs/YRyTyqkvDzca5G1MSdAlKe7G95AZ/DICwJ5RI8nWq1MKCsPMJqNG6Se\\nffoWHsz9M82kWb+oIhjBXKtNxlobH1ETv8EoakBkjeuOWLBGsxD8DRtaOW6b37Yj\\nxmeL2esmZMuTNIbwBjRbtGebwnpqx6nkBTH8ACXq123/y+toTitPXn0PsgaT/Jbn\\nYwIDAQAB\\n-----END PUBLIC KEY-----"\r\n}', '43eea10034c64e2e8776b4271beac0c147b800d2cce2368e4f23ecff7dc36e9a', 3971, '2018-12-09 21:33:04'),
	(2019, 4, '000895b84d3e78a8c80de62805a16271f2eac19caad28d7959c77bd4c8d721a1', '000959831c688fba357add69362546fc1ff8c344e52ee623bd096f4fb0bc22e4', '{\r\n"V":"4",\r\n"H":"SHA256",\r\n"VT":"2019-12-27T13:28:06.419Z",\r\n"CN":"node10.consensuspki.org",\r\n"SP": 5510,\r\n"PublicKey":"-----BEGIN PUBLIC KEY-----\\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlutRyuAYyuQL74Q0Pufr\\nwQtv7FT1L6dlQSpBLyLyncRdPxKLJuEv4TdSXfgyDX4z6TQB4s6dF90duVvHEuwh\\nEQnKJU3MWvI2kKaI//tmaktyqCZfWiffrGJBqPYG/8w5ztNc9pt/UsEwbm1fGs23\\nxo74Z3GKouvUf1SNNCfCVIbdLCKKn2AwRk3n8WSjbMsdRfa5alZpIsMxU7717quP\\nM8M6EtfCUHsnEMyyINKyUz0peusg74AGcSY753hnE73SmHfQet8QJ/KP6IHTC7Nu\\nQSBc4c2377ubZKqB7kz86EsNM1B39IAjtJNM3rFPjZvZnbkuyhHqChSjG592WKWz\\n/QIDAQAB\\n-----END PUBLIC KEY-----"\r\n}', 'b49f0f850e8a65b25cc3855f0b7ac0e513e1d8eeb85b1eacb302959133905f9e', 1899, '2018-12-09 21:33:30'),
	(2019, 1, '0ca561624ac48c8fff4891a01f7a132a9889197f9655a1e6375dc08388203deb', '0005ee047031101fdf1464d16d7fce935fe28e776a0aec062b1bc87d223c0ed2', '{\r\n"V":"4",\r\n"H":"SHA256",\r\n"VT":"2019-10-27T13:28:06.419Z",\r\n"CN":"node7.consensuspki.org",\r\n"SP": 5507,\r\n"PublicKey":"-----BEGIN PUBLIC KEY-----\\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu+/3qynljcobBBqVCc4x\\nhfZkBD18h1TeywTNuFuzo+xDVvI8wOFd5jYpyVgYf4UkTbqvbHjOM8eFRKzWMpAN\\nf2B2Paw9Q9Bq6geX6DyoOMfU24mc0u5QriJuxOBTjaYaJcYyw80ayw1dkGuTmvVI\\n+tcP0NfkOuORkw5XXbKkzFssjUr/sxv8Wl2SR6xplu5gY06K6UCeG3tyEo8Z1KJl\\neQEpZD5U5um1ZdTUHgDjOoxVq2WkRi+01BQoG5WYxMMk73RdLefbVGYv/iw0Jh9p\\nBi2tUo2RS+YiY+M6kUA/7Hg7+zFRxYcUsl2ykPHq69iLxXOBrZDTePIitNBMl2iC\\niQIDAQAB\\n-----END PUBLIC KEY-----"\r\n}', 'f7058158bd9cd3b91fbcd387e5a091a7c3faedf6a0bd79c7994331139badae54', 2670, '2018-12-09 21:31:29'),
	(2018, 6, '000532b4d4de8c60a2f376fff373c48c8a5831a0076d09e24f90f8d0d22ac512', '00037722a893655e42148e1400a678f248a4212b42baae89bf841d132d36bc98', '{\r\n"V":"4",\r\n"H":"SHA256",\r\n"VT":"2018-12-29T13:28:06.419Z",\r\n"CN":"node6.consensuspki.org",\r\n"SP": 5506,\r\n"PublicKey":"-----BEGIN PUBLIC KEY-----\\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAumOynCK4lGin08kbt2ns\\nlQOS/mG5e/Jdzx2BkdkbrtGmOlRTC9mkEjlXwxcZu+B+m6cg1G/8AMTIbquumcZD\\nNTtlu/OOnd1bMFt25ECfg9e+C1IHL8O8OuWIYeyIU/AJKIeKP1gGAXbQuHIHTXT9\\n6KyCGH1PM27+mkZcSCrDBYU474Smk7iCqqsWaRH9tnKKXHmqYaZqV7gwu9zwbLsR\\nvrpYhMVYDa71biENyJvSUkTcq3Uc3+mLy+SzfRIfH/0K9FuGjLpCk2OdF6zxk9nN\\nS5NjW5E3R563orCaAkhHiEkxul2VDo7/S6v15lGv5M2xmYM5PgNZUlTyzVPL+XI4\\nTwIDAQAB\\n-----END PUBLIC KEY-----"\r\n}', '755f3b1e093b218a810b19c0a4cd10869719d77ad4a13b2f36e11393d10d6bb2', 1735, '2018-12-09 21:30:30');
/*!40000 ALTER TABLE `ca_certificateblockchain` ENABLE KEYS */;

-- Dumping data for table consensuspki.ca_evidenceblockchain: ~0 rows (approximately)
/*!40000 ALTER TABLE `ca_evidenceblockchain` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_evidenceblockchain` ENABLE KEYS */;

-- Dumping data for table consensuspki.ca_rootblockchain: ~0 rows (approximately)
/*!40000 ALTER TABLE `ca_rootblockchain` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_rootblockchain` ENABLE KEYS */;

-- Dumping data for table consensuspki.ca_subjects: ~10 rows (approximately)
/*!40000 ALTER TABLE `ca_subjects` DISABLE KEYS */;
INSERT INTO `ca_subjects` (`YEAR`, `HEIGHT`, `SUBJECT`) VALUES
	(2018, 1, 'node1.consensuspki.org'),
	(2018, 4, 'node4.consensuspki.org'),
	(2018, 2, 'node2.consensuspki.org'),
	(2018, 3, 'node3.consensuspki.org'),
	(2018, 6, 'node6.consensuspki.org'),
	(2018, 5, 'node5.consensuspki.org'),
	(2019, 3, 'node9.consensuspki.org'),
	(2019, 1, 'node7.consensuspki.org'),
	(2019, 4, 'node10.consensuspki.org'),
	(2019, 2, 'node8.consensuspki.org');
/*!40000 ALTER TABLE `ca_subjects` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

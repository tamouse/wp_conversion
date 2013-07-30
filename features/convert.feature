Feature: convert a wordpress export to markdown
  In order to convert a wordpress export to markdown
  I will need run the conversion script

  Background:
    Given a test export xml file

  Scenario: run the conversion script
    When I successfully run "wp_conversion" with the test file
    Then the exit status should be 0
    And the output should match /^$/
    And the following directories should exist:
      |pages|
      |posts|
      |attachments|
    And the following files should exist:
      | posts/2010-05-03-introduction.markdown                                                    |
      | posts/2010-05-03-thematic.markdown                                                        |
      | posts/2010-05-28-a-problem-with-partial-lines.markdown                                    |
      | posts/2010-05-28-buddymatic.markdown                                                      |
      | posts/2010-05-29-another-problem-cant-set-background-colour-on-menu-bounding-box.markdown |
      | posts/2013-07-06-this-site-is-going-away.markdown                                         |
      | pages/a-haiku.markdown                                                                    |
      | pages/a-little-child.markdown                                                             |
      | pages/a-new-poem.markdown                                                                 |
      | pages/and-you-learn.markdown                                                              |
      | pages/be-careful-what-you-say-the-power-of-words.markdown                                 |

  Scenario: save the items as yaml files
    When I successfully run "wp_conversion" with the "yaml" switch and the test file
    Then the exit status should be 0
    And the output should match /^$/
    And the following directories should exist:
      |pages|
      |posts|
      |attachments|
    And the following files should exist:
      | posts/2010-05-03-introduction.yaml                                                    |
      | posts/2010-05-03-thematic.yaml                                                        |
      | posts/2010-05-28-a-problem-with-partial-lines.yaml                                    |
      | posts/2010-05-28-buddymatic.yaml                                                      |
      | posts/2010-05-29-another-problem-cant-set-background-colour-on-menu-bounding-box.yaml |
      | posts/2013-07-06-this-site-is-going-away.yaml                                         |
      | pages/a-haiku.yaml                                                                    |
      | pages/a-little-child.yaml                                                             |
      | pages/a-new-poem.yaml                                                                 |
      | pages/and-you-learn.yaml                                                              |
      | pages/be-careful-what-you-say-the-power-of-words.yaml                                 |

    

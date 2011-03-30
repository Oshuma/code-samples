<?php
/**
 * Handles flash messages (output to the User).
 *
 * Disclaimer: This was written quite a few years ago.
 *
 * Usage:
 *   // Let's assume this is a global var (doesn't have to be).
 *   $flash = new Flash();
 *
 *   // In a controller somewhere:
 *   $flash->set("Some error went down!", 'error');
 *
 *   // Later on, in the view:
 *   if ($flash->messages_waiting()) {
 *     $flash->show();
 *   }
 */
class Flash {
  /**
   * @var string $name Class name.
   */
  private $name = "Flash";

  /**
   * @var array $flash_types Array to hold flash message types.
   */
  private $flash_types = array('debug', 'notice', 'warning');

  /**
   * Flash constructor.
   */
  public function __construct() {
  }

  /**
   * Clear flash messages.
   *
   * @todo Add optional parameter to select type of flash to clear.
   */
  public function clear() {
    foreach ( $this->flash_types as $type ) {
      unset($_SESSION['flash_' . $type]);
    }
  }

  /**
   * Check if there are flash messages in the session.
   * @return boolean true if messages waiting, false if not.
   */
  public function messages_waiting() {
    $messages = false;
    foreach ( $this->flash_types as $type ) {
      if ( !empty($_SESSION['flash_' . $type]) ) {
        $messages = true; // Found a message waiting.
      }
    }
    return $messages;
  }

  /**
   * Sets a flash message in the session.
   * @param string $message Message to display.
   * @param string $type Type of flash message, defaults to 'notice'
   */
  public function set( $message, $type = 'notice' ) {
    if ( in_array($type, $this->flash_types) ) {
      if ( $type == 'debug' ) {
        $_SESSION['flash_' . $type] = "DEBUG: " . $message;
      } else {
        $_SESSION['flash_' . $type] = $message;
      }
    } else {
      // Unknown flash type.  This can probably be handled better.
      return false;
    }
  }

  /**
   * Shows any flash messages in the session.
   *
   * @param boolean $echo If true (the default) the tag will be returned instead of echoed.
   * @todo Add optional parameter that selects flash type to show.
   */
  public function show($echo = true) {
    foreach ( $this->flash_types as $type ) {
      if ( !empty($_SESSION['flash_' . $type]) and in_array($type, $this->flash_types) ) {
        $tag = "<div class='flash_" . $type . "'>" . $_SESSION['flash_' . $type] . "</div>";
        unset($_SESSION['flash_' . $type]);
        if ($echo)
          echo $tag;
        else
          return $tag;
      }
    }
  }

}

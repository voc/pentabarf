<?php

require_once("entity.php");

/**
 * Class for accessing, manipulating, creating and deleting records in event_role_state.
*/

class Event_Role_State extends Entity
{

  public function __construct($select = array())
  {
    $this->table = "event_role_state";
    $this->order = "";
    $this->domain = "valuelist";
    $this->field['event_role_state_id']['type'] = 'SERIAL';
    $this->field['event_role_state_id']['not_null'] = true;
    $this->field['event_role_id']['type'] = 'INTEGER';
    $this->field['event_role_id']['not_null'] = true;
    $this->field['tag']['type'] = 'VARCHAR';
    $this->field['tag']['length'] = 32;
    $this->field['tag']['not_null'] = true;
    $this->field['rank']['type'] = 'INTEGER';
    $this->field['event_role_state_id']['primary_key'] = true;
    parent::__construct($select);
  }

}

?>

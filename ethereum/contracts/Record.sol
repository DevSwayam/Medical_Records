// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Record {
    struct Patient {
        string ic;
        string name;
        string phone;
        string gender;
        string dob;
        string height;
        string weight;
        string houseaddr;
        string bloodgroup;
        string allergies;
        string medication;
        string emergencyName;
        string emergencyContact;
        uint date;
    }

    struct Doctor {
        string ic;
        string name;
        string phone;
        string gender;
        string dob;
        string qualification;
        string major;
        uint date;
    }

    struct Appointment {
        address doctoraddr;
        address patientaddr;
        string date;
        string time;
        string prescription;
        string description;
        string diagnosis;
        string status;
        uint creationDate;
    }

    address public owner;
    address[] public patientList;
    address[] public doctorList;
    address[] public appointmentList;

    mapping(address => Patient) public patients;
    mapping(address => Doctor) public doctors;
    mapping(address => Appointment) public appointments;

    mapping(address => mapping(address => bool)) public isApproved;
    mapping(address => bool) public isPatient;
    mapping(address => bool) public isDoctor;
    mapping(address => uint) public appointmentCountPerPatient;

    uint256 public patientCount = 0;
    uint256 public doctorCount = 0;
    uint256 public appointmentCount = 0;
    uint256 public permissionGrantedCount = 0;

    constructor() {
        owner = msg.sender;
    }

    function setDetails(
        string memory _ic,
        string memory _name,
        string memory _phone,
        string memory _gender,
        string memory _dob,
        string memory _height,
        string memory _weight,
        string memory _houseaddr,
        string memory _bloodgroup,
        string memory _allergies,
        string memory _medication,
        string memory _emergencyName,
        string memory _emergencyContact
    ) public {
        require(!isPatient[msg.sender]);
        Patient storage p = patients[msg.sender];

        p.ic = _ic;
        p.name = _name;
        p.phone = _phone;
        p.gender = _gender;
        p.dob = _dob;
        p.height = _height;
        p.weight = _weight;
        p.houseaddr = _houseaddr;
        p.bloodgroup = _bloodgroup;
        p.allergies = _allergies;
        p.medication = _medication;
        p.emergencyName = _emergencyName;
        p.emergencyContact = _emergencyContact;
        p.date = block.timestamp;

        patientList.push(msg.sender);
        isPatient[msg.sender] = true;
        isApproved[msg.sender][msg.sender] = true;
        patientCount++;
    }

    // Add other functions with reduced local variables similarly

    // ...

    function givePermission(address _address) public returns (bool success) {
        isApproved[msg.sender][_address] = true;
        permissionGrantedCount++;
        return true;
    }

     function revokePermission(address _address) public returns (bool success) {
        isApproved[msg.sender][_address] = false;
        return true;
    }

    function getPatients() public view returns (address[] memory) {
        return patientList;
    }

    function getDoctors() public view returns (address[] memory) {
        return doctorList;
    }

    function getAppointments() public view returns (address[] memory) {
        return appointmentList;
    }

    function searchPatientDemographic(address _address) public view returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        require(isApproved[_address][msg.sender]);

        Patient storage p = patients[_address];

        return (p.ic, p.name, p.phone, p.gender, p.dob, p.height, p.weight);
    }

    function searchPatientMedical(address _address) public view returns (string memory, string memory, string memory, string memory, string memory, string memory) {
        require(isApproved[_address][msg.sender]);

        Patient storage p = patients[_address];

        return (p.houseaddr, p.bloodgroup, p.allergies, p.medication, p.emergencyName, p.emergencyContact);
    }

    function searchDoctor(address _address) public view returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        require(isDoctor[_address]);

        Doctor storage d = doctors[_address];

        return (d.ic, d.name, d.phone, d.gender, d.dob, d.qualification, d.major);
    }

    function searchAppointment(address _address) public view returns (address, string memory, string memory, string memory, string memory, string memory, string memory, string memory) {
        Appointment storage a = appointments[_address];
        Doctor storage d = doctors[a.doctoraddr];

        return (a.doctoraddr, d.name, a.date, a.time, a.diagnosis, a.prescription, a.description, a.status);
    }

    function searchRecordDate(address _address) public view returns (uint) {
        Patient storage p = patients[_address];

        return p.date;
    }

    function searchDoctorDate(address _address) public view returns (uint) {
        Doctor storage d = doctors[_address];

        return d.date;
    }

    function searchAppointmentDate(address _address) public view returns (uint) {
        Appointment storage a = appointments[_address];

        return a.creationDate;
    }

    function getPatientCount() public view returns (uint256) {
        return patientCount;
    }

    function getDoctorCount() public view returns (uint256) {
        return doctorCount;
    }

    function getAppointmentCount() public view returns (uint256) {
        return appointmentCount;
    }

    function getPermissionGrantedCount() public view returns (uint256) {
        return permissionGrantedCount;
    }

    function getAppointmentCountPerPatient(address _address) public view returns (uint256) {
        return appointmentCountPerPatient[_address];
    }
}

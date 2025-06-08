function updatePoolingDataset_old() {
  var sourceSpreadsheetId = "1Ia10xULe8AHMKDQGfidlf9eBdi0RUtZe4OQlFeF_ELY"; // ใส่ ID ของไฟล์ฐานข้อมูล
  var sourceSheetName = "Shipment"; // ชื่อชีตต้นทาง
  var targetSheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Pooling Dataset"); // ชื่อชีตปลายทาง

  // เปิดไฟล์ต้นทางและดึงข้อมูล
  var sourceSpreadsheet = SpreadsheetApp.openById(sourceSpreadsheetId);
  var sourceSheet = sourceSpreadsheet.getSheetByName(sourceSheetName);
  var sourceData = sourceSheet.getDataRange().getValues();

  // ดึงข้อมูลจากชีตปลายทาง
  var targetData = targetSheet.getDataRange().getValues();
  var targetMap = {}; // เก็บข้อมูลปลายทางในรูปแบบ Object เพื่อค้นหาได้ง่าย

  // สร้าง Mapping ข้อมูลปลายทางตามคีย์เฉพาะ เช่น คอลัมน์ที่ 1
  targetData.forEach((row, index) => {
    var key = row[2] + "-" + row[3]; // ใช้คอลัมน์ 1 และ 2 รวมกันเป็นคีย์
    if (key) {
      targetMap[key] = {
        data: row,
        index: index + 1, // เก็บ index ของแถวในชีต (เริ่มจาก 1)
      };
    }
  });

  // เตรียมข้อมูลใหม่
  sourceData.forEach((row) => {
    var key = row[2] + "-" + row[3]; // ใช้คอลัมน์ 1 และ 2 รวมกันเป็นคีย์
    if (key && targetMap[key]) {
      // ถ้ามีแถวเดิมอยู่แล้ว ให้แก้ไขเฉพาะคอลัมน์ 1-5
      var targetRowIndex = targetMap[key].index;
      targetSheet.getRange(targetRowIndex, 1, 1, 14).setValues([row.slice(0, 14)]);
    } else {
      var material = row[5];
      var gate = "";
      switch (material) {
        case "2CTFB040-150-150":
            gate = "K2";
            break;
        case "2CTFB040-200-200":
            gate = "K2";
            break;
        case "2CTFB060-100-100":
            gate = "K2";
            break;
        case "2CTFB060-150-100":
            gate = "K2";
            break;
        case "2CTFB060-150-150":
            gate = "K2";
            break;
        case "2CTFB060-200-200":
            gate = "K2";
            break;
        case "2CTFB060-250-250":
            gate = "K2";
            break;
        case "2CTFB060-300-300":
            gate = "K2";
            break;
        case "2CTFB090-100-100":
            gate = "K2";
            break;
        case "2CTFB090-150-100":
            gate = "K2";
            break;
        case "2CTFB090-150-150":
            gate = "K2";
            break;
        case "2CTFB090-200-150":
            gate = "K2";
            break;
        case "2CTFB090-200-200":
            gate = "K2";
            break;
        case "2CTFB090-250-250":
            gate = "K2";
            break;
        case "2CTFB090-300-300":
            gate = "K2";
            break;
        case "2CTFB120-150-150":
            gate = "K2";
            break;
        case "2CTFB120-200-200":
            gate = "K2";
            break;
        case "2CTFB120-250-250":
            gate = "K2";
            break;
        case "2CTFB120-300-300":
            gate = "K2";
            break;
			
		case "2FB027-0250-003":
			gate = "K8";
            break;
        case "2FB027-0320-004":
			gate = "K8";
            break;
        case "2FB027-0350-004":
			gate = "K8";
            break;
        case "2FB027-0380-005":
			gate = "K8";
            break;
        case "2FB027-0500-006":
			gate = "K8";
            break;
        case "2FB027-0750-010":
			gate = "K8";
            break;
        case "2FB027-1000-013":
			gate = "K8";
            break;
        case "2FB028-0250-003":
			gate = "K8";
            break;
        case "2FB028-0320-004":
			gate = "K8";
            break;
        case "2FB028-0380-005":
			gate = "K8";
            break;
        case "2FB028-0500-007":
			gate = "K8";
            break;
        case "2FB028-0750-010":
			gate = "K8";
            break;
        case "2FB028-1000-013":
			gate = "K8";
            break;
        case "2FB032-0250-004":
			gate = "K8";
            break;
        case "2FB032-0320-005":
			gate = "K8";
            break;
        case "2FB032-0380-006":
			gate = "K8";
            break;
        case "2FB032-0500-008":
			gate = "K8";
            break;
        case "2FB032-0750-011":
			gate = "K8";
            break;
        case "2FB032-1000-015":
			gate = "K8";
            break;
        case "2FB050-0250-006":
			gate = "K4";
            break;
        case "2FB050-0320-008":
			gate = "K4";
            break;
        case "2FB050-0380-009":
			gate = "K4";
            break;
        case "2FB050-0500-012":
			gate = "K4";
            break;
        case "2FB050-0750-018":
			gate = "K4";
            break;
        case "2FB050-1000-024":
			gate = "K4";
            break;
        case "2FB090-0250-011":
			gate = "K4";
            break;
        case "2FB090-0320-014":
			gate = "K4";
            break;
        case "2FB090-0380-016":
			gate = "K4";
            break;
        case "2FB090-0500-021":
			gate = "K4";
            break;
        case "2FB090-0650-028":
			gate = "K4";
            break;
        case "2FB090-0750-032":
			gate = "K4";
            break;
        case "2FB090-1000-042":
			gate = "K4";
            break;
        case "2FB090-1250-053":
			gate = "K4";
            break;
        case "2FB090-1500-064":
			gate = "K4";
            break;
			
		case "2FB030-0190-003":
            gate = "K6";
            break;
        case "2FB030-0250-004":
            gate = "K6";
            break;
        case "2FB030-0320-005":
            gate = "K6";
            break;
        case "2FB030-0380-006":
            gate = "K6";
            break;
        case "2FB030-0500-007":
            gate = "K6";
            break;
        case "2FB030-0750-011":
            gate = "K6";
            break;
        case "2FB030-1000-014":
            gate = "K6";
            break;
        case "2FB030-1250-018":
            gate = "K6";
            break;
        case "2FB030-1500-021":
            gate = "K6";
            break;
        case "2FB040-0250-005":
            gate = "K6";
            break;
        case "2FB040-0320-006":
            gate = "K6";
            break;
        case "2FB040-0380-007":
            gate = "K6";
            break;
        case "2FB040-0500-009":
            gate = "K6";
            break;
        case "2FB040-0750-015":
            gate = "K6";
            break;
        case "2FB040-1000-019":
            gate = "K6";
            break;
        case "2FB050-0250-006":
            gate = "K6";
            break;
        case "2FB050-0320-008":
            gate = "K6";
            break;
        case "2FB050-0380-009":
            gate = "K6";
            break;
        case "2FB050-0500-012":
            gate = "K6";
            break;
        case "2FB050-0750-018":
            gate = "K6";
            break;
        case "2FB050-1000-024":
            gate = "K6";
            break;
        case "2FB060-0250-007":
            gate = "K6";
            break;
        case "2FB060-0320-009":
            gate = "K6";
            break;
        case "2FB060-0380-011":
            gate = "K6";
            break;
        case "2FB060-0500-014":
            gate = "K6";
            break;
        case "2FB060-0650-018":
            gate = "K6";
            break;
        case "2FB060-0750-021":
            gate = "K6";
            break;
        case "2FB060-1000-028":
            gate = "K6";
            break;
        case "2FB060-1250-035":
            gate = "K6";
            break;
        case "2FB060-1500-042":
            gate = "K6";
            break;
        case "2FB100-0250-012":
            gate = "K6";
            break;
        case "2FB100-0320-015":
            gate = "K6";
            break;
        case "2FB100-0380-018":
            gate = "K6";
            break;
        case "2FB100-0500-024":
            gate = "K6";
            break;
        case "2FB100-0750-035":
            gate = "K6";
            break;
        case "2FB100-1000-047":
            gate = "K6";
            break;
			
		case "2FB025-0250-003":
			gate = "K8";
            break;
        case "2FB025-0320-004":
			gate = "K8";
            break;
        case "2FB025-0380-005":
			gate = "K8";
            break;
        case "2FB025-0500-006":
			gate = "K8";
            break;
        case "2FB025-0750-009":
			gate = "K8";
            break;
        case "2FB025-1000-012":
			gate = "K8";
            break;
        case "2FB045-0250-005":
			gate = "K8";
            break;
        case "2FB045-0320-007":
			gate = "K8";
            break;
        case "2FB045-0380-008":
			gate = "K8";
            break;
        case "2FB045-0500-011":
			gate = "K8";
            break;
        case "2FB045-0750-016":
			gate = "K8";
            break;
        case "2FB045-1000-021":
			gate = "K8";
            break;
        case "2FB080-0250-009":
			gate = "K8";
            break;
        case "2FB080-0320-012":
			gate = "K8";
            break;
        case "2FB080-0380-014":
			gate = "K8";
            break;
        case "2FB080-0500-019":
			gate = "K8";
            break;
        case "2FB080-0650-024":
			gate = "K8";
            break;
        case "2FB080-0750-028":
			gate = "K8";
            break;
        case "2FB080-0800-030":
			gate = "K8";
            break;
        case "2FB080-1000-038":
			gate = "K8";
            break;
        case "2FB080-1250-047":
			gate = "K8";
            break;
        case "2FB120-0250-014":
			gate = "K8";
            break;
        case "2FB120-0320-018":
			gate = "K8";
            break;
        case "2FB120-0380-021":
			gate = "K8";
            break;
        case "2FB120-0500-028":
			gate = "K8";
            break;
        case "2FB120-0650-037":
			gate = "K8";
            break;
        case "2FB120-0750-042":
			gate = "K8";
            break;
        case "2FB120-1000-057":
			gate = "K8";
            break;
        case "2FB120-1250-071":
			gate = "K8";
            break;
        case "2FB120-1500-085":
			gate = "K8";
            break;
        case "2FB150-0500-035":
			gate = "K8";
            break;
        case "2FB150-0750-053":
			gate = "K8";
            break;
        case "2FB150-1000-071":
			gate = "K8";
            break;
        case "2FB160-0500-038":
			gate = "K8";
            break;
        case "2FB160-0750-057":
			gate = "K8";
            break;
        case "2FB160-0750-VCS":
			gate = "K8";
            break;
        case "2FB160-1000-075":
			gate = "K8";
            break;
        case "2FB190-0500-045":
			gate = "K8";
            break;
        case "2FB190-0750-067":
			gate = "K8";
            break;
        case "2FB190-1000-090":
			gate = "K8";
            break;
        case "2FB200-0500-047":
			gate = "K8";
            break;
        case "2FB200-0750-071":
			gate = "K8";
            break;
        case "2FB200-1000-094":
			gate = "K8";
            break;
        case "2FB250-0500-059":
			gate = "K8";
            break;
        case "2FB250-0750-088":
			gate = "K8";
            break;
        case "2FB250-1000-118":
			gate = "K8";
            break;
			
		default:
			gate = "";
            break;
      }
      // ถ้าเป็นแถวใหม่ ให้เพิ่มเข้าไป
      targetSheet.appendRow([...row.slice(0, 14), "ปกติ", gate, "0"]); // เพิ่มแถวใหม่พร้อมเว้นคอลัมน์ 6
    }
  });
}

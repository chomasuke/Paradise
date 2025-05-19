import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Box, Section, DmIcon, Button } from '../components';
import { toTitleCase } from 'common/string';

type Design = {
  name: string;
  desc: string;
  cost: Record<string, number>;
  id: string;
  categories: string[];
  icon: string;
  IconState: string;
};

type Material = {
  name: string;
  ref: string;
  amount: number;
};

type ComponentPrinterData = {
  designs: Record<string, Design>;
  materials: Material[];
};
// Это плохо, это недоделано, это похуй, это потом.
export const ComponentPrinter = (props) => {
  const { act, data } = useBackend<ComponentPrinterData>();
  const { designs } = data;

  return (
    <Window title={'Хуй'} width={670} height={600}>
      <Window.Content>
        <Box>
          {Object.values(designs).map((design) => (
            <Section key={design.id}>
              <DmIcon
                icon={design.icon}
                icon_state={design.IconState}
                style={{
                  'vertical-align': 'middle',
                  width: '32px',
                  margin: '0px',
                  'margin-left': '0px',
                }}
              />
              <Button
                mr={1}
                icon="hammer"
                tooltip={design.desc}
                onClick={() =>
                  act('print', {
                    designId: design.id,
                  })
                }
              >
                {toTitleCase(design.name)}
              </Button>

              {(design.cost &&
                Object.keys(design.cost)
                  .map((mat) => toTitleCase(mat) + ': ' + design.cost[mat])
                  .join(', ')) || <Box>No resources required.</Box>}

              <Button
                mr={1}
                icon="trash-can"
                position="absolute"
                right={1}
                top={1}
                onClick={() =>
                  act('del_design', {
                    designId: design.id,
                  })
                }
              />
            </Section>
          ))}
        </Box>
      </Window.Content>
    </Window>
  );
};
